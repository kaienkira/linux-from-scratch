LFS_HTOP_VERSION = 3.4.1
LFS_HTOP_SRC_TAR = $(abspath src/htop-$(LFS_HTOP_VERSION).tar.xz)
LFS_HTOP_SRC_DIR = $(abspath src/htop-$(LFS_HTOP_VERSION))

.PHONY: \
htop-extract-src \
htop-build \
htop-clean

htop-extract-src:
	rm -rf "$(LFS_HTOP_SRC_DIR)"
	tar -xvf "$(LFS_HTOP_SRC_TAR)" -C src/

htop-build:
	$(MAKE) htop-extract-src
	cd "$(LFS_HTOP_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_HTOP_SRC_DIR)"

htop-clean:
	rm -rf "$(LFS_HTOP_SRC_DIR)"
