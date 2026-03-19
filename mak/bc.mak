LFS_BC_VERSION = 1.08.2
LFS_BC_SRC_TAR = $(abspath src/bc-$(LFS_BC_VERSION).tar.gz)
LFS_BC_SRC_DIR = $(abspath src/bc-$(LFS_BC_VERSION))

.PHONY: \
bc-extract-src \
bc-build \
bc-clean

bc-extract-src:
	rm -rf "$(LFS_BC_SRC_DIR)"
	tar -xvf "$(LFS_BC_SRC_TAR)" -C src/

bc-build:
	$(MAKE) bc-extract-src
	cd "$(LFS_BC_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_BC_SRC_DIR)"

bc-clean:
	rm -rf "$(LFS_BC_SRC_DIR)"
