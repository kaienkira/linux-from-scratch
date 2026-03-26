LFS_EXPAT_VERSION = 2.7.5
LFS_EXPAT_SRC_TAR = $(abspath src/expat-$(LFS_EXPAT_VERSION).tar.xz)
LFS_EXPAT_SRC_DIR = $(abspath src/expat-$(LFS_EXPAT_VERSION))

.PHONY: \
expat-extract-src \
expat-build \
expat-clean

expat-extract-src:
	rm -rf "$(LFS_EXPAT_SRC_DIR)"
	tar -xvf "$(LFS_EXPAT_SRC_TAR)" -C src/

expat-build:
	$(MAKE) expat-extract-src
	cd "$(LFS_EXPAT_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--disable-static \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_EXPAT_SRC_DIR)"

expat-clean:
	rm -rf "$(LFS_EXPAT_SRC_DIR)"
