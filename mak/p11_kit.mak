LFS_P11_KIT_VERSION = 0.26.2
LFS_P11_KIT_SRC_TAR = $(abspath src/p11-kit-$(LFS_P11_KIT_VERSION).tar.xz)
LFS_P11_KIT_SRC_DIR = $(abspath src/p11-kit-$(LFS_P11_KIT_VERSION))

.PHONY: \
p11-kit-extract-src \
p11-kit-build \
p11-kit-clean

p11-kit-extract-src:
	rm -rf "$(LFS_P11_KIT_SRC_DIR)"
	tar -xvf "$(LFS_P11_KIT_SRC_TAR)" -C src/
	cd "$(LFS_P11_KIT_SRC_DIR)" && \
		sed '20,$$ d' -i trust/trust-extract-compat && \
		printf '/usr/libexec/make-ca/copy-trust-modifications\n' \
			>> trust/trust-extract-compat && \
		printf '/usr/sbin/make-ca -r\n' \
			>> trust/trust-extract-compat

p11-kit-build:
	$(MAKE) p11-kit-extract-src
	mkdir -p "$(LFS_P11_KIT_SRC_DIR)"/build
	cd "$(LFS_P11_KIT_SRC_DIR)"/build && \
		meson setup .. \
			--prefix=/usr \
			--buildtype=release \
			-D trust_paths=/etc/pki/anchors \
			&& \
		ninja -j$(NPROC) && \
		ninja install
	ln -sfv \
		/usr/libexec/p11-kit/trust-extract-compat \
		/usr/bin/update-ca-certificates
	rm -rf "$(LFS_P11_KIT_SRC_DIR)"

p11-kit-clean:
	rm -rf "$(LFS_P11_KIT_SRC_DIR)"
