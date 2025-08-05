GCC_SRC_DIR = $(abspath src/gcc-15.1.0)

.PHONY: \
gcc-build-p1

gcc-build-p1:
	ln -sf "$(GMP_SRC_DIR)" "$(GCC_SRC_DIR)"/gmp
	ln -sf "$(MPFR_SRC_DIR)" "$(GCC_SRC_DIR)"/mpfr
	ln -sf "$(MPC_SRC_DIR)" "$(GCC_SRC_DIR)"/mpc
	mkdir -p "$(GCC_SRC_DIR)"/build_p1
	cd "$(GCC_SRC_DIR)"/build_p1 && \
		../configure \
			--prefix="$(LFS_ROOT_DIR)"/tools \
			--with-sysroot="$(LFS_ROOT_DIR)" \
			--target=$(LFS_COMPILE_TARGET) \
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

# libgomp -> GNU Offloading and Multi-Processing Project (OpenMP & OpenACC Support)
# libatomic -> __atomic_load, __atomic_store, std::atomic
# libquadmath -> __float128
# libssp -> Stack Smashing Protection -fstack-protector
# libvtv -> Vtable Verification

gcc-clean:
	rm -f "$(GCC_SRC_DIR)"/gmp
	rm -f "$(GCC_SRC_DIR)"/mpfr
	rm -f "$(GCC_SRC_DIR)"/mpc
	rm -rf "$(GCC_SRC_DIR)"/build_p1
