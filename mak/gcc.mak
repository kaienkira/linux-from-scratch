LFS_GCC_VERSION = 15.2.0
LFS_GCC_PATCH_VERSION = 5
LFS_GCC_SRC_TAR = $(abspath src/gcc-$(LFS_GCC_VERSION).tar.xz)
LFS_GCC_SRC_DIR = $(abspath src/gcc-$(LFS_GCC_VERSION))
LFS_GCC_PATCH_TAR = $(abspath src/gcc_patch-$(LFS_GCC_VERSION)-$(LFS_GCC_PATCH_VERSION).tar.xz)

# __cxa_atexit -> -fuse-cxa-atexit
# cet -> -fcf-protection=full
#        -fcf-protection=branch (IBT)
#        -fcf-protection=return (SHSTK)
# libgomp -> GNU Offloading and Multi-Processing Project (OpenMP & OpenACC Support)
# libatomic -> __atomic_load, __atomic_store, std::atomic
# libquadmath -> __float128
# libssp -> Stack Smashing Protection -fstack-protector
# libvtv -> Vtable Verification

.PHONY: \
gcc-extract-src \
gcc-extract-dep \
gcc-build-p1 \
gcc-build-p1-libstdcxx \
gcc-build-p2 \
gcc-build \
gcc-clean

gcc-extract-src:
	rm -rf "$(LFS_GCC_SRC_DIR)"
	tar -xvf "$(LFS_GCC_SRC_TAR)" -C src/
	tar -xvf "$(LFS_GCC_PATCH_TAR)" -C "$(LFS_GCC_SRC_DIR)"
	for f in `ls $(LFS_GCC_SRC_DIR)/patches/*.patch`; \
	do \
		patch -d "$(LFS_GCC_SRC_DIR)" -N -p1 -i $$f; \
		if [ $$? -ne 0 ]; then exit 1; fi; \
	done

gcc-extract-dep:
	tar -xvf "$(LFS_GMP_SRC_TAR)" -C "$(LFS_GCC_SRC_DIR)"
	mv "$(LFS_GCC_SRC_DIR)/gmp-$(LFS_GMP_VERSION)" "$(LFS_GCC_SRC_DIR)/gmp"
	tar -xvf "$(LFS_MPFR_SRC_TAR)" -C "$(LFS_GCC_SRC_DIR)"
	mv "$(LFS_GCC_SRC_DIR)/mpfr-$(LFS_MPFR_VERSION)" "$(LFS_GCC_SRC_DIR)/mpfr"
	tar -xvf "$(LFS_MPC_SRC_TAR)" -C "$(LFS_GCC_SRC_DIR)"
	mv "$(LFS_GCC_SRC_DIR)/mpc-$(LFS_MPC_VERSION)" "$(LFS_GCC_SRC_DIR)/mpc"

gcc-build-p1:
	$(MAKE) gcc-extract-src
	$(MAKE) gcc-extract-dep
	cd "$(LFS_GCC_SRC_DIR)" && \
		sed -i '/m64=/s/lib64/lib/' gcc/config/i386/t-linux64
	mkdir -p "$(LFS_GCC_SRC_DIR)"/build
	cd "$(LFS_GCC_SRC_DIR)"/build && \
		../configure \
			--target=$(LFS_COMPILE_TARGET) \
			--prefix="$(LFS_ROOT_DIR)"/tools \
			--with-sysroot="$(LFS_ROOT_DIR)" \
			--disable-libatomic \
			--disable-libgomp \
			--disable-libquadmath \
			--disable-libssp \
			--disable-libstdcxx \
			--disable-libvtv \
			--disable-multilib \
			--disable-nls \
			--disable-shared \
			--disable-threads \
			--disable-werror \
			--enable-default-pie \
			--enable-default-ssp \
			--enable-languages=c,c++ \
			--with-glibc-version=$(LFS_GLIBC_VERSION) \
			--with-newlib \
			--without-headers \
			&& \
		make -j$(NPROC) && \
		make install
	cd "$(LFS_GCC_SRC_DIR)" && \
		cat gcc/limitx.h gcc/glimits.h gcc/limity.h \
			>"$(LFS_ROOT_DIR)"/tools/lib/gcc/$(LFS_COMPILE_TARGET)/$(LFS_GCC_VERSION)/include/limits.h
	rm -rf "$(LFS_GCC_SRC_DIR)"

gcc-build-p1-libstdcxx:
	$(MAKE) gcc-extract-src
	$(MAKE) gcc-extract-dep
	mkdir -p "$(LFS_GCC_SRC_DIR)"/build
	cd "$(LFS_GCC_SRC_DIR)"/build && \
		../libstdc++-v3/configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			--disable-multilib \
			--disable-nls \
			--disable-libstdcxx-pch \
			--with-gxx-include-dir=/tools/$(LFS_COMPILE_TARGET)/include/c++/$(LFS_GCC_VERSION) \
			&& \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install
	rm -f $(LFS_ROOT_DIR)/usr/lib/libstdc++.la
	rm -f $(LFS_ROOT_DIR)/usr/lib/libstdc++exp.la
	rm -f $(LFS_ROOT_DIR)/usr/lib/libstdc++fs.la
	rm -f $(LFS_ROOT_DIR)/usr/lib/libsupc++.la
	rm -rf "$(LFS_GCC_SRC_DIR)"

gcc-build-p2:
	$(MAKE) gcc-extract-src
	$(MAKE) gcc-extract-dep
	cd "$(LFS_GCC_SRC_DIR)" && \
		sed -i '/m64=/s/lib64/lib/' gcc/config/i386/t-linux64 && \
		sed -i '/thread_header =/s/@.*@/gthr-posix.h/' \
			libgcc/Makefile.in libstdc++-v3/include/Makefile.in
	mkdir -p "$(LFS_GCC_SRC_DIR)"/build
	cd "$(LFS_GCC_SRC_DIR)"/build && \
		../configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--target=$(LFS_COMPILE_TARGET) \
			--prefix=/usr \
			--disable-libatomic \
			--disable-libgomp \
			--disable-libquadmath \
			--disable-libsanitizer \
			--disable-libssp \
			--disable-libvtv \
			--disable-multilib \
			--disable-nls \
			--with-build-sysroot=$(LFS_ROOT_DIR) \
			--enable-default-pie \
			--enable-default-ssp \
			--enable-languages=c,c++ \
			LDFLAGS_FOR_TARGET=-L$(PWD)/$(LFS_COMPILE_TARGET)/libgcc \
			&& \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install
	cd "$(LFS_ROOT_DIR)"/usr/bin && \
		ln -sf gcc cc
	rm -rf "$(LFS_GCC_SRC_DIR)"

gcc-build:
	$(MAKE) gcc-extract-src
	cd "$(LFS_GCC_SRC_DIR)" && \
		sed -i 's/char [*]q/const &/' libgomp/affinity-fmt.c && \
		sed -i '/m64=/s/lib64/lib/' gcc/config/i386/t-linux64
	mkdir -p "$(LFS_GCC_SRC_DIR)"/build
	cd "$(LFS_GCC_SRC_DIR)"/build && \
		../configure \
			--prefix=/usr \
			--disable-bootstrap \
			--disable-fixincludes \
			--disable-multilib \
			--enable-default-pie \
			--enable-default-ssp \
			--enable-host-pie \
			--enable-languages=c,c++ \
			--with-system-zlib \
			LD=ld \
			&& \
		make -j$(NPROC) && \
		make install
	cd /usr/bin && \
		ln -sf gcc cc
	mkdir -pv /usr/share/gdb/auto-load/usr/lib
	mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib
	rm -rf "$(LFS_GCC_SRC_DIR)"

gcc-clean:
	rm -rf "$(LFS_GCC_SRC_DIR)"
