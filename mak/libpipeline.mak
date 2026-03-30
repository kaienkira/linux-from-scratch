LFS_LIBPIPELINE_VERSION = 1.5.8
LFS_LIBPIPELINE_SRC_TAR = $(abspath src/libpipeline-$(LFS_LIBPIPELINE_VERSION).tar.gz)
LFS_LIBPIPELINE_SRC_DIR = $(abspath src/libpipeline-$(LFS_LIBPIPELINE_VERSION))

.PHONY: \
libpipeline-extract-src \
libpipeline-build \
libpipeline-clean

libpipeline-extract-src:
	rm -rf "$(LFS_LIBPIPELINE_SRC_DIR)"
	tar -xvf "$(LFS_LIBPIPELINE_SRC_TAR)" -C src/

libpipeline-build:
	$(MAKE) libpipeline-extract-src
	cd "$(LFS_LIBPIPELINE_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_LIBPIPELINE_SRC_DIR)"

libpipeline-clean:
	rm -rf "$(LFS_LIBPIPELINE_SRC_DIR)"
