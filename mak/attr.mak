LFS_ATTR_VERSION = 2.5.2
LFS_ATTR_SRC_TAR = $(abspath src/attr-$(LFS_ATTR_VERSION).tar.gz)
LFS_ATTR_SRC_DIR = $(abspath src/attr-$(LFS_ATTR_VERSION))

.PHONY: \
attr-extract-src \
attr-build \
attr-clean

attr-extract-src:
	rm -rf "$(LFS_ATTR_SRC_DIR)"
	tar -xvf "$(LFS_ATTR_SRC_TAR)" -C src/

attr-build:
	$(MAKE) attr-extract-src
	cd "$(LFS_ATTR_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--sysconfdir=/etc \
			--disable-static \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_ATTR_SRC_DIR)"

attr-clean:
	rm -rf "$(LFS_ATTR_SRC_DIR)"
