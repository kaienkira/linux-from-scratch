LFS_ACL_VERSION = 2.3.2
LFS_ACL_SRC_TAR = $(abspath src/acl-$(LFS_ACL_VERSION).tar.xz)
LFS_ACL_SRC_DIR = $(abspath src/acl-$(LFS_ACL_VERSION))

.PHONY: \
acl-extract-src \
acl-build \
acl-clean

acl-extract-src:
	rm -rf "$(LFS_ACL_SRC_DIR)"
	tar -xvf "$(LFS_ACL_SRC_TAR)" -C src/

acl-build:
	$(MAKE) acl-extract-src
	cd "$(LFS_ACL_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--disable-static \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_ACL_SRC_DIR)"

acl-clean:
	rm -rf "$(LFS_ACL_SRC_DIR)"
