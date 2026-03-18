LFS_LZ4_VERSION = 1.10.0
LFS_LZ4_SRC_TAR = $(abspath src/lz4-$(LFS_LZ4_VERSION).tar.gz)
LFS_LZ4_SRC_DIR = $(abspath src/lz4-$(LFS_LZ4_VERSION))

.PHONY: \
lz4-extract-src \
lz4-build \
lz4-clean

lz4-extract-src:
	rm -rf "$(LFS_LZ4_SRC_DIR)"
	tar -xvf "$(LFS_LZ4_SRC_TAR)" -C src/

lz4-build:
	$(MAKE) lz4-extract-src
	cd "$(LFS_LZ4_SRC_DIR)" && \
		make BUILD_STATIC=no PREFIX=/usr -j$(NPROC) && \
		make BUILD_STATIC=no PREFIX=/usr install
	rm -rf "$(LFS_LZ4_SRC_DIR)"

lz4-clean:
	rm -rf "$(LFS_LZ4_SRC_DIR)"
