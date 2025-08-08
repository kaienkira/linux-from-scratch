BINUTILS_SRC_DIR = $(abspath src/binutils-2.45)

# cet -> Control-flow Enforcement Technology

.PHONY: \
binutils-build-p1 \
binutils-clean

binutils-build-p1:
	mkdir -p "$(BINUTILS_SRC_DIR)"/build_p1
	cd "$(BINUTILS_SRC_DIR)"/build_p1 && \
		../configure \
			--target=$(LFS_COMPILE_TARGET) \
			--prefix="$(LFS_ROOT_DIR)"/tools \
			--with-sysroot="$(LFS_ROOT_DIR)" \
			--enable-gprofng=no \
			--enable-new-dtags \
			--enable-default-hash-style=gnu \
			--disable-nls \
			--disable-werror && \
		make -j$(NPROC) && \
		make install

binutils-clean:
	rm -rf "$(BINUTILS_SRC_DIR)"/build_p1
