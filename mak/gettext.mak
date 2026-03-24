LFS_GETTEXT_VERSION = 1.0
LFS_GETTEXT_SRC_TAR = $(abspath src/gettext-$(LFS_GETTEXT_VERSION).tar.xz)
LFS_GETTEXT_SRC_DIR = $(abspath src/gettext-$(LFS_GETTEXT_VERSION))

.PHONY: \
gettext-extract-src \
gettext-build-chroot-p1 \
gettext-build \
gettext-clean

gettext-extract-src:
	rm -rf "$(LFS_GETTEXT_SRC_DIR)"
	tar -xvf "$(LFS_GETTEXT_SRC_TAR)" -C src/

gettext-build-chroot-p1:
	$(MAKE) gettext-extract-src
	cd "$(LFS_GETTEXT_SRC_DIR)" && \
		./configure \
			--disable-shared \
			&& \
		make -j$(NPROC) && \
		cp gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin
	rm -rf "$(LFS_GETTEXT_SRC_DIR)"

gettext-build:
	$(MAKE) gettext-extract-src
	cd "$(LFS_GETTEXT_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--disable-static \
			&& \
		make -j$(NPROC) && \
		make install
	chmod 0755 /usr/lib/preloadable_libintl.so
	rm -rf "$(LFS_GETTEXT_SRC_DIR)"

gettext-clean:
	rm -rf "$(LFS_GETTEXT_SRC_DIR)"
