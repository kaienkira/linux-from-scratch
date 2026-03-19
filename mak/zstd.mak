LFS_ZSTD_VERSION = 1.5.7
LFS_ZSTD_SRC_TAR = $(abspath src/zstd-$(LFS_ZSTD_VERSION).tar.gz)
LFS_ZSTD_SRC_DIR = $(abspath src/zstd-$(LFS_ZSTD_VERSION))

.PHONY: \
zstd-extract-src \
zstd-build \
zstd-clean

zstd-extract-src:
	rm -rf "$(LFS_ZSTD_SRC_DIR)"
	tar -xvf "$(LFS_ZSTD_SRC_TAR)" -C src/

zstd-build:
	$(MAKE) zstd-extract-src
	cd "$(LFS_ZSTD_SRC_DIR)" && \
		make prefix=/usr -j$(NPROC) && \
		make prefix=/usr install
	rm -f /usr/lib/libzstd.a
	rm -rf "$(LFS_ZSTD_SRC_DIR)"

zstd-clean:
	rm -rf "$(LFS_ZSTD_SRC_DIR)"
