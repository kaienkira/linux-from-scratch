LFS_MAN_PAGES_VERSION = 6.17
LFS_MAN_PAGES_SRC_TAR = $(abspath src/man-pages-$(LFS_MAN_PAGES_VERSION).tar.xz)
LFS_MAN_PAGES_SRC_DIR = $(abspath src/man-pages-$(LFS_MAN_PAGES_VERSION))

.PHONY: \
man-pages-extract-src \
man-pages-build \
man-pages-clean

man-pages-extract-src:
	rm -rf "$(LFS_MAN_PAGES_SRC_DIR)"
	tar -xvf "$(LFS_MAN_PAGES_SRC_TAR)" -C src/
	rm $(LFS_MAN_PAGES_SRC_DIR)/man3/crypt*

man-pages-build:
	$(MAKE) man-pages-extract-src
	cd "$(LFS_MAN_PAGES_SRC_DIR)" && \
		make -R GIT=false prefix=/usr install
	rm -rf "$(LFS_MAN_PAGES_SRC_DIR)"

man-pages-clean:
	rm -rf "$(LFS_MAN_PAGES_SRC_DIR)"
