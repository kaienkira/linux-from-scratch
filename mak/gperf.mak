LFS_GPERF_VERSION = 3.3
LFS_GPERF_SRC_TAR = $(abspath src/gperf-$(LFS_GPERF_VERSION).tar.gz)
LFS_GPERF_SRC_DIR = $(abspath src/gperf-$(LFS_GPERF_VERSION))

.PHONY: \
gperf-extract-src \
gperf-build \
gperf-clean

gperf-extract-src:
	rm -rf "$(LFS_GPERF_SRC_DIR)"
	tar -xvf "$(LFS_GPERF_SRC_TAR)" -C src/

gperf-build:
	$(MAKE) gperf-extract-src
	cd "$(LFS_GPERF_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_GPERF_SRC_DIR)"

gperf-clean:
	rm -rf "$(LFS_GPERF_SRC_DIR)"
