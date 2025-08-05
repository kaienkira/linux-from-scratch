BINUTILS_SRC_DIR = $(abspath src/binutils-2.45)

.PHONY: \
binutils-build-p1 \
binutils-clean

binutils-build-p1:
	mkdir -p "$(BINUTILS_SRC_DIR)"/build_p1
	cd "$(BINUTILS_SRC_DIR)"/build_p1 && \
		../configure \
			--prefix="$(LFS_ROOT_DIR)"/tools \
			--with-sysroot="$(LFS_ROOT_DIR)" \
			--target=$(LFS_COMPILE_TARGET) \
			--disable-nls \
			--enable-gprofng=no \
			--disable-werror \
			--enable-new-dtags \
			--enable-default-hash-style=gnu && \
		make -j$(NPROC) && \
		make install

binutils-clean:
	rm -rf "$(BINUTILS_SRC_DIR)"/build_p1
