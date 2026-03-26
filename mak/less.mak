LFS_LESS_VERSION = 692
LFS_LESS_SRC_TAR = $(abspath src/less-$(LFS_LESS_VERSION).tar.gz)
LFS_LESS_SRC_DIR = $(abspath src/less-$(LFS_LESS_VERSION))

.PHONY: \
less-extract-src \
less-build \
less-clean

less-extract-src:
	rm -rf "$(LFS_LESS_SRC_DIR)"
	tar -xvf "$(LFS_LESS_SRC_TAR)" -C src/

less-build:
	$(MAKE) less-extract-src
	cd "$(LFS_LESS_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--sysconfdir=/etc \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_LESS_SRC_DIR)"

less-clean:
	rm -rf "$(LFS_LESS_SRC_DIR)"
