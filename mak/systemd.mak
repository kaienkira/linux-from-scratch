LFS_SYSTEMD_VERSION = 260.1
LFS_SYSTEMD_SRC_TAR = $(abspath src/systemd-$(LFS_SYSTEMD_VERSION).tar.gz)
LFS_SYSTEMD_SRC_DIR = $(abspath src/systemd-$(LFS_SYSTEMD_VERSION))

.PHONY: \
systemd-extract-src \
systemd-build \
systemd-clean

systemd-extract-src:
	rm -rf "$(LFS_SYSTEMD_SRC_DIR)"
	tar -xvf "$(LFS_SYSTEMD_SRC_TAR)" -C src/
	cd "$(LFS_SYSTEMD_SRC_DIR)" && \
		sed -e 's/GROUP="render"/GROUP="video"/' \
			-e 's/GROUP="sgx", //' \
			-i rules.d/50-udev-default.rules.in

systemd-build:
	$(MAKE) systemd-extract-src
	mkdir -p "$(LFS_SYSTEMD_SRC_DIR)"/build
	cd "$(LFS_SYSTEMD_SRC_DIR)"/build && \
		meson setup .. \
			--prefix=/usr \
			--buildtype=release \
			-D default-dnssec=no \
			-D dev-kvm-mode=0660 \
			-D firstboot=false \
			-D homed=disabled \
			-D install-tests=false \
			-D ldconfig=false \
			-D man=disabled \
			-D mode=release \
			-D nobody-group=nogroup \
			-D pamconfdir=no \
			-D rpmmacrosdir=no \
			-D sysupdate=disabled \
			-D sysusers=false \
			-D ukify=disabled \
			&& \
		ninja -j$(NPROC) && \
		ninja install
	systemd-machine-id-setup
	systemctl preset-all
	rm -rf "$(LFS_SYSTEMD_SRC_DIR)"

systemd-clean:
	rm -rf "$(LFS_SYSTEMD_SRC_DIR)"
