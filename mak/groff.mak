LFS_GROFF_VERSION = 1.24.1
LFS_GROFF_SRC_TAR = $(abspath src/groff-$(LFS_GROFF_VERSION).tar.gz)
LFS_GROFF_SRC_DIR = $(abspath src/groff-$(LFS_GROFF_VERSION))

.PHONY: \
groff-extract-src \
groff-build \
groff-clean

groff-extract-src:
	rm -rf "$(LFS_GROFF_SRC_DIR)"
	tar -xvf "$(LFS_GROFF_SRC_TAR)" -C src/

groff-build:
	$(MAKE) groff-extract-src
	cd "$(LFS_GROFF_SRC_DIR)" && \
		PAGE=A4 ./configure \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_GROFF_SRC_DIR)"

groff-clean:
	rm -rf "$(LFS_GROFF_SRC_DIR)"
