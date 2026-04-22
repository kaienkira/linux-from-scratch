LFS_LIBXML2_VERSION = 2.15.3
LFS_LIBXML2_SRC_TAR = $(abspath src/libxml2-$(LFS_LIBXML2_VERSION).tar.xz)
LFS_LIBXML2_SRC_DIR = $(abspath src/libxml2-$(LFS_LIBXML2_VERSION))

.PHONY: \
libxml2-extract-src \
libxml2-build \
libxml2-clean

libxml2-extract-src:
	rm -rf "$(LFS_LIBXML2_SRC_DIR)"
	tar -xvf "$(LFS_LIBXML2_SRC_TAR)" -C src/

libxml2-build:
	$(MAKE) libxml2-extract-src
	mkdir -p "$(LFS_LIBXML2_SRC_DIR)"/build
	cd "$(LFS_LIBXML2_SRC_DIR)"/build && \
		meson setup .. \
			--prefix=/usr \
			--buildtype=release \
			-D history=enabled \
			&& \
		ninja -j$(NPROC) && \
		ninja install
	rm -rf "$(LFS_LIBXML2_SRC_DIR)"

libxml2-clean:
	rm -rf "$(LFS_LIBXML2_SRC_DIR)"
