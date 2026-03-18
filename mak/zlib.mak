LFS_ZLIB_VERSION = 1.3.2
LFS_ZLIB_SRC_TAR = $(abspath src/zlib-$(LFS_ZLIB_VERSION).tar.gz)
LFS_ZLIB_SRC_DIR = $(abspath src/zlib-$(LFS_ZLIB_VERSION))

.PHONY: \
zlib-extract-src \
zlib-build \
zlib-clean

zlib-extract-src:
	rm -rf "$(LFS_ZLIB_SRC_DIR)"
	tar -xvf "$(LFS_ZLIB_SRC_TAR)" -C src/

zlib-build:
	$(MAKE) zlib-extract-src
	cd "$(LFS_ZLIB_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make install
	rm -f /usr/lib/libz.a
	rm -rf "$(LFS_ZLIB_SRC_DIR)"

zlib-clean:
	rm -rf "$(LFS_ZLIB_SRC_DIR)"
