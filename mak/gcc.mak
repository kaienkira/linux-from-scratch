GCC_VERSION = 15.1.0
GCC_SRC_DIR = $(abspath src/gcc-$(GCC_VERSION))

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
gcc-build-p1 \
gcc-build-libstdcxx \
gcc-clean

gcc-build-p1:
	ln -sf "$(GMP_SRC_DIR)" "$(GCC_SRC_DIR)"/gmp
	ln -sf "$(MPFR_SRC_DIR)" "$(GCC_SRC_DIR)"/mpfr
	ln -sf "$(MPC_SRC_DIR)" "$(GCC_SRC_DIR)"/mpc
	cd "$(GCC_SRC_DIR)" && \
		sed -i '/m64=/s/lib64/lib/' gcc/config/i386/t-linux64
	mkdir -p "$(GCC_SRC_DIR)"/build_p1
	cd "$(GCC_SRC_DIR)"/build_p1 && \
		../configure \
			--target=$(LFS_COMPILE_TARGET) \
			--prefix="$(LFS_ROOT_DIR)"/tools \
			--libexecdir="$(LFS_ROOT_DIR)"/tools/lib \
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
			--enable-__cxa_atexit \
			--enable-cet=auto \
			--enable-checking=release \
			--enable-clocale=newlib \
			--enable-default-pie \
			--enable-default-ssp \
			--enable-gnu-indirect-function \
			--enable-gnu-unique-object \
			--enable-languages=c,c++ \
			--enable-link-serialization=1 \
			--enable-linker-build-id \
			--enable-lto \
			--with-glibc-version=$(GLIBC_VERSION) \
			--with-linker-hash-style=gnu \
			--with-newlib \
			--without-headers && \
		make -j$(NPROC) && \
		make install
	cd "$(GCC_SRC_DIR)" && \
		cat gcc/limitx.h gcc/glimits.h gcc/limity.h \
			>"$(LFS_ROOT_DIR)"/tools/lib/gcc/$(LFS_COMPILE_TARGET)/$(GCC_VERSION)/include/limits.h

gcc-build-libstdcxx:
	mkdir -p "$(GCC_SRC_DIR)"/build_libstdcxx
	cd "$(GCC_SRC_DIR)"/build_libstdcxx && \
		../libstdc++-v3/configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			--disable-multilib \
			--disable-nls \
			--disable-libstdcxx-pch \
			--enable-libstdcxx-backtrace \
			--with-gxx-include-dir=/tools/$(LFS_COMPILE_TARGET)/include/c++/$(GCC_VERSION) && \
	make -j$(NPROC) && \
	make DESTDIR="$(LFS_ROOT_DIR)" install
	rm -f $(LFS_ROOT_DIR)/usr/lib/libstdc++.la
	rm -f $(LFS_ROOT_DIR)/usr/lib/libstdc++exp.la
	rm -f $(LFS_ROOT_DIR)/usr/lib/libstdc++fs.la
	rm -f $(LFS_ROOT_DIR)/usr/lib/libsupc++.la

gcc-clean:
	rm -f "$(GCC_SRC_DIR)"/gmp
	rm -f "$(GCC_SRC_DIR)"/mpfr
	rm -f "$(GCC_SRC_DIR)"/mpc
	rm -rf "$(GCC_SRC_DIR)"/build_p1
	rm -rf "$(GCC_SRC_DIR)"/build_libstdcxx
