LFS_LIBUNISTRING_VERSION = 1.4.2
LFS_LIBUNISTRING_SRC_TAR = $(abspath src/libunistring-$(LFS_LIBUNISTRING_VERSION).tar.gz)
LFS_LIBUNISTRING_SRC_DIR = $(abspath src/libunistring-$(LFS_LIBUNISTRING_VERSION))

.PHONY: \
libunistring-extract-src \
libunistring-build \
libunistring-clean

libunistring-extract-src:
	rm -rf "$(LFS_LIBUNISTRING_SRC_DIR)"
	tar -xvf "$(LFS_LIBUNISTRING_SRC_TAR)" -C src/

libunistring-build:
	$(MAKE) libunistring-extract-src
	cd "$(LFS_LIBUNISTRING_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--disable-static \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_LIBUNISTRING_SRC_DIR)"

libunistring-clean:
	rm -rf "$(LFS_LIBUNISTRING_SRC_DIR)"
