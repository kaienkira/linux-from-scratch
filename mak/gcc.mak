LFS_GCC_VERSION = 15.2.0
LFS_GCC_SRC_TAR = $(abspath src/gcc-$(LFS_GCC_VERSION).tar.xz)
LFS_GCC_SRC_DIR = $(abspath src/gcc-$(LFS_GCC_VERSION))

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
gcc-build-p1 \
gcc-build-p1-libstdcxx \
gcc-clean

gcc-extract-src:
	rm -rf "$(LFS_GCC_SRC_DIR)"
	tar -xvf "$(LFS_GCC_SRC_TAR)" -C src/
	tar -xvf "$(LFS_GMP_SRC_TAR)" -C "$(LFS_GCC_SRC_DIR)"
	mv "$(LFS_GCC_SRC_DIR)/gmp-$(LFS_GMP_VERSION)" "$(LFS_GCC_SRC_DIR)/gmp"
	tar -xvf "$(LFS_MPFR_SRC_TAR)" -C "$(LFS_GCC_SRC_DIR)"
	mv "$(LFS_GCC_SRC_DIR)/mpfr-$(LFS_MPFR_VERSION)" "$(LFS_GCC_SRC_DIR)/mpfr"
	tar -xvf "$(LFS_MPC_SRC_TAR)" -C "$(LFS_GCC_SRC_DIR)"
	mv "$(LFS_GCC_SRC_DIR)/mpc-$(LFS_MPC_VERSION)" "$(LFS_GCC_SRC_DIR)/mpc"

gcc-build-p1:
	$(MAKE) gcc-extract-src
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
	cd "$(LFS_GCC_SRC_DIR)" && \
		sed -i '/m64=/s/lib64/lib/' gcc/config/i386/t-linux64 && \
		sed -i '/thread_header =/s/@.*@/gthr-posix.h/' \
			libgcc/Makefile.in libstdc++-v3/include/Makefile.in
	mkdir -p "$(LFS_GCC_SRC_DIR)"/build
	cd "$(LFS_GCC_SRC_DIR)"/build && \
		../configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
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

gcc-clean:
	rm -rf "$(LFS_GCC_SRC_DIR)"
