LFS_PKGCONF_VERSION = 2.5.1
LFS_PKGCONF_SRC_TAR = $(abspath src/pkgconf-$(LFS_PKGCONF_VERSION).tar.xz)
LFS_PKGCONF_SRC_DIR = $(abspath src/pkgconf-$(LFS_PKGCONF_VERSION))

.PHONY: \
pkgconf-extract-src \
pkgconf-build \
pkgconf-clean

pkgconf-extract-src:
	rm -rf "$(LFS_PKGCONF_SRC_DIR)"
	tar -xvf "$(LFS_PKGCONF_SRC_TAR)" -C src/

pkgconf-build:
	$(MAKE) pkgconf-extract-src
	cd "$(LFS_PKGCONF_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--disable-static \
			&& \
		make -j$(NPROC) && \
		make install
	cd /usr/bin && \
		ln -sf pkgconfig pkg-config
	rm -rf "$(LFS_PKGCONF_SRC_DIR)"

pkgconf-clean:
	rm -rf "$(LFS_PKGCONF_SRC_DIR)"
