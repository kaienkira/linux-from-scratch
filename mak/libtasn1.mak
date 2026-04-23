LFS_LIBTASN1_VERSION = 4.21.0
LFS_LIBTASN1_SRC_TAR = $(abspath src/libtasn1-$(LFS_LIBTASN1_VERSION).tar.gz)
LFS_LIBTASN1_SRC_DIR = $(abspath src/libtasn1-$(LFS_LIBTASN1_VERSION))

.PHONY: \
libtasn1-extract-src \
libtasn1-build \
libtasn1-clean

libtasn1-extract-src:
	rm -rf "$(LFS_LIBTASN1_SRC_DIR)"
	tar -xvf "$(LFS_LIBTASN1_SRC_TAR)" -C src/

libtasn1-build:
	$(MAKE) libtasn1-extract-src
	cd "$(LFS_LIBTASN1_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--disable-static \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_LIBTASN1_SRC_DIR)"

libtasn1-clean:
	rm -rf "$(LFS_LIBTASN1_SRC_DIR)"
