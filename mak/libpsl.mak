LFS_LIBPSL_VERSION = 0.21.5
LFS_LIBPSL_SRC_TAR = $(abspath src/libpsl-$(LFS_LIBPSL_VERSION).tar.gz)
LFS_LIBPSL_SRC_DIR = $(abspath src/libpsl-$(LFS_LIBPSL_VERSION))

.PHONY: \
libpsl-extract-src \
libpsl-build \
libpsl-clean

libpsl-extract-src:
	rm -rf "$(LFS_LIBPSL_SRC_DIR)"
	tar -xvf "$(LFS_LIBPSL_SRC_TAR)" -C src/

libpsl-build:
	$(MAKE) libpsl-extract-src
	mkdir -p "$(LFS_LIBPSL_SRC_DIR)"/build
	cd "$(LFS_LIBPSL_SRC_DIR)"/build && \
		meson setup .. \
			--prefix=/usr \
			--buildtype=release \
			&& \
		ninja -j$(NPROC) && \
		ninja install
	rm -rf "$(LFS_LIBPSL_SRC_DIR)"

libpsl-clean:
	rm -rf "$(LFS_LIBPSL_SRC_DIR)"
