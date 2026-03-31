LFS_TEXINFO_VERSION = 7.3
LFS_TEXINFO_SRC_TAR = $(abspath src/texinfo-$(LFS_TEXINFO_VERSION).tar.xz)
LFS_TEXINFO_SRC_DIR = $(abspath src/texinfo-$(LFS_TEXINFO_VERSION))

.PHONY: \
texinfo-extract-src \
texinfo-build-chroot-p1 \
texinfo-build \
texinfo-clean

texinfo-extract-src:
	rm -rf "$(LFS_TEXINFO_SRC_DIR)"
	tar -xvf "$(LFS_TEXINFO_SRC_TAR)" -C src/

texinfo-build-chroot-p1:
	$(MAKE) texinfo-extract-src
	cd "$(LFS_TEXINFO_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_TEXINFO_SRC_DIR)"

texinfo-build:
	$(MAKE) texinfo-extract-src
	cd "$(LFS_TEXINFO_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_TEXINFO_SRC_DIR)"

texinfo-clean:
	rm -rf "$(LFS_TEXINFO_SRC_DIR)"
