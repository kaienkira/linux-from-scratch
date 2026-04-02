LFS_LIBNL_VERSION = 3.12.0
LFS_LIBNL_SRC_TAR = $(abspath src/libnl-$(LFS_LIBNL_VERSION).tar.gz)
LFS_LIBNL_SRC_DIR = $(abspath src/libnl-$(LFS_LIBNL_VERSION))

.PHONY: \
libnl-extract-src \
libnl-build \
libnl-clean

libnl-extract-src:
	rm -rf "$(LFS_LIBNL_SRC_DIR)"
	tar -xvf "$(LFS_LIBNL_SRC_TAR)" -C src/

libnl-build:
	$(MAKE) libnl-extract-src
	cd "$(LFS_LIBNL_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--disable-static \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_LIBNL_SRC_DIR)"

libnl-clean:
	rm -rf "$(LFS_LIBNL_SRC_DIR)"
