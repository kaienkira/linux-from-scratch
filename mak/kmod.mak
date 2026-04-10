LFS_KMOD_VERSION = 34.2
LFS_KMOD_SRC_TAR = $(abspath src/kmod-$(LFS_KMOD_VERSION).tar.xz)
LFS_KMOD_SRC_DIR = $(abspath src/kmod-$(LFS_KMOD_VERSION))

.PHONY: \
kmod-extract-src \
kmod-build \
kmod-clean

kmod-extract-src:
	rm -rf "$(LFS_KMOD_SRC_DIR)"
	tar -xvf "$(LFS_KMOD_SRC_TAR)" -C src/

kmod-build:
	$(MAKE) kmod-extract-src
	mkdir -p "$(LFS_KMOD_SRC_DIR)"/build
	cd "$(LFS_KMOD_SRC_DIR)"/build && \
		meson setup .. \
			--prefix=/usr \
			--buildtype=release \
			-D manpages=false \
			&& \
		ninja -j$(NPROC) && \
		ninja install
	rm -rf "$(LFS_KMOD_SRC_DIR)"

kmod-clean:
	rm -rf "$(LFS_KMOD_SRC_DIR)"
