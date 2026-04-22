LFS_IPUTILS_VERSION = 20250605
LFS_IPUTILS_SRC_TAR = $(abspath src/iputils-$(LFS_IPUTILS_VERSION).tar.xz)
LFS_IPUTILS_SRC_DIR = $(abspath src/iputils-$(LFS_IPUTILS_VERSION))

.PHONY: \
iputils-extract-src \
iputils-build \
iputils-clean

iputils-extract-src:
	rm -rf "$(LFS_IPUTILS_SRC_DIR)"
	tar -xvf "$(LFS_IPUTILS_SRC_TAR)" -C src/

iputils-build:
	$(MAKE) iputils-extract-src
	mkdir -p "$(LFS_IPUTILS_SRC_DIR)"/build
	cd "$(LFS_IPUTILS_SRC_DIR)"/build && \
		meson setup .. \
			--prefix=/usr \
			--buildtype=release \
			&& \
		ninja -j$(NPROC) && \
		ninja install
	rm -rf "$(LFS_IPUTILS_SRC_DIR)"

iputils-clean:
	rm -rf "$(LFS_IPUTILS_SRC_DIR)"
