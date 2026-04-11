LFS_DBUS_VERSION = 1.16.2
LFS_DBUS_SRC_TAR = $(abspath src/dbus-$(LFS_DBUS_VERSION).tar.xz)
LFS_DBUS_SRC_DIR = $(abspath src/dbus-$(LFS_DBUS_VERSION))

.PHONY: \
dbus-extract-src \
dbus-build \
dbus-clean

dbus-extract-src:
	rm -rf "$(LFS_DBUS_SRC_DIR)"
	tar -xvf "$(LFS_DBUS_SRC_TAR)" -C src/

dbus-build:
	$(MAKE) dbus-extract-src
	mkdir "$(LFS_DBUS_SRC_DIR)"/build
	cd "$(LFS_DBUS_SRC_DIR)"/build && \
		meson setup .. \
			--prefix=/usr \
			--buildtype=release \
			--wrap-mode=nofallback \
			&& \
		ninja -j$(NPROC) && \
		ninja install
	ln -sfv /etc/machine-id /var/lib/dbus
	rm -rf "$(LFS_DBUS_SRC_DIR)"

dbus-clean:
	rm -rf "$(LFS_DBUS_SRC_DIR)"
