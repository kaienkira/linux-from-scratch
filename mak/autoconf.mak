LFS_AUTOCONF_VERSION = 2.73
LFS_AUTOCONF_SRC_TAR = $(abspath src/autoconf-$(LFS_AUTOCONF_VERSION).tar.xz)
LFS_AUTOCONF_SRC_DIR = $(abspath src/autoconf-$(LFS_AUTOCONF_VERSION))

.PHONY: \
autoconf-extract-src \
autoconf-build \
autoconf-clean

autoconf-extract-src:
	rm -rf "$(LFS_AUTOCONF_SRC_DIR)"
	tar -xvf "$(LFS_AUTOCONF_SRC_TAR)" -C src/

autoconf-build:
	$(MAKE) autoconf-extract-src
	cd "$(LFS_AUTOCONF_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_AUTOCONF_SRC_DIR)"

autoconf-clean:
	rm -rf "$(LFS_AUTOCONF_SRC_DIR)"
