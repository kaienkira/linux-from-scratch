LFS_LIBTOOL_VERSION = 2.5.4
LFS_LIBTOOL_SRC_TAR = $(abspath src/libtool-$(LFS_LIBTOOL_VERSION).tar.xz)
LFS_LIBTOOL_SRC_DIR = $(abspath src/libtool-$(LFS_LIBTOOL_VERSION))

.PHONY: \
libtool-extract-src \
libtool-build \
libtool-clean

libtool-extract-src:
	rm -rf "$(LFS_LIBTOOL_SRC_DIR)"
	tar -xvf "$(LFS_LIBTOOL_SRC_TAR)" -C src/

libtool-build:
	$(MAKE) libtool-extract-src
	cd "$(LFS_LIBTOOL_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_LIBTOOL_SRC_DIR)"

libtool-clean:
	rm -rf "$(LFS_LIBTOOL_SRC_DIR)"
