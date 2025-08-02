BINUTILS_SRC_DIR = $(abspath src/binutils-2.45)

binutils-compile:
	mkdir -p "$(BINUTILS_SRC_DIR)"/build
	cd "$(BINUTILS_SRC_DIR)"/build && \
		../configure \
			--prefix="$(LFS_TOOLS_DIR)" \
			--with-sysroot="$(LFS_ROOT_DIR)" \
			--target=$(LFS_TARGET) \
			--disable-nls \
			--enable-gprofng=no \
			--disable-werror \
			--enable-new-dtags \
			--enable-default-hash-style=gnu && \
		make -j$(NPROC) && \
		make install
