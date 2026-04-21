LFS_LIBIDN2_VERSION = 2.3.8
LFS_LIBIDN2_SRC_TAR = $(abspath src/libidn2-$(LFS_LIBIDN2_VERSION).tar.gz)
LFS_LIBIDN2_SRC_DIR = $(abspath src/libidn2-$(LFS_LIBIDN2_VERSION))

.PHONY: \
libidn2-extract-src \
libidn2-build \
libidn2-clean

libidn2-extract-src:
	rm -rf "$(LFS_LIBIDN2_SRC_DIR)"
	tar -xvf "$(LFS_LIBIDN2_SRC_TAR)" -C src/

libidn2-build:
	$(MAKE) libidn2-extract-src
	cd "$(LFS_LIBIDN2_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--disable-static \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_LIBIDN2_SRC_DIR)"

libidn2-clean:
	rm -rf "$(LFS_LIBIDN2_SRC_DIR)"
