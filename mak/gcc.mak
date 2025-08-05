GCC_VERSION = 15.1.0
GCC_SRC_DIR = $(abspath src/gcc-$(GCC_VERSION))

# libgomp -> GNU Offloading and Multi-Processing Project (OpenMP & OpenACC Support)
# libatomic -> __atomic_load, __atomic_store, std::atomic
# libquadmath -> __float128
# libssp -> Stack Smashing Protection -fstack-protector
# libvtv -> Vtable Verification

.PHONY: \
gcc-build-p1

gcc-build-p1:
	ln -sf "$(GMP_SRC_DIR)" "$(GCC_SRC_DIR)"/gmp
	ln -sf "$(MPFR_SRC_DIR)" "$(GCC_SRC_DIR)"/mpfr
	ln -sf "$(MPC_SRC_DIR)" "$(GCC_SRC_DIR)"/mpc
	sed -i '/m64=/s/lib64/lib/' gcc/config/i386/t-linux64
	mkdir -p "$(GCC_SRC_DIR)"/build_p1
	cd "$(GCC_SRC_DIR)"/build_p1 && \
		../configure \
			--target=$(LFS_COMPILE_TARGET) \
			--prefix="$(LFS_ROOT_DIR)"/tools \
			--with-sysroot="$(LFS_ROOT_DIR)" \
			--with-glibc-version=$(GLIBC_VERSION) \
			--with-newlib \
			--without-headers \
			--enable-default-pie \
			--enable-default-ssp \
			--disable-shared \
			--disable-multilib \
			--disable-nls \
			--disable-threads \
			--disable-libatomic \
			--disable-libgomp \
			--disable-libquadmath \
			--disable-libssp \
			--disable-libvtv \
			--disable-libstdcxx \
			--enable-languages=c,c++ && \
		make -j$(NPROC) && \
		make install

gcc-build-libstdcxx-p1:
	mkdir -p "$(GCC_SRC_DIR)"/build_libstdcxx_p1
	cd "$(GCC_SRC_DIR)"/build_libstdcxx_p1 && \
		../libstdc++-v3/configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			--disable-multilib \
			--disable-nls \
			--disable-libstdcxx-pch \
			--with-gxx-include-dir=/tools/$(LFS_COMPILE_TARGET)/include/c++/$(GCC_VERSION) && \
	make -j$(NPROC) && \
	make DESTDIR="$(LFS_ROOT_DIR)" install

gcc-clean:
	rm -f "$(GCC_SRC_DIR)"/gmp
	rm -f "$(GCC_SRC_DIR)"/mpfr
	rm -f "$(GCC_SRC_DIR)"/mpc
	rm -rf "$(GCC_SRC_DIR)"/build_p1
	rm -rf "$(GCC_SRC_DIR)"/build_p1_libstdcxx
