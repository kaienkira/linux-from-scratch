LFS_PATCH_VERSION = 2.8
LFS_PATCH_SRC_TAR = $(abspath src/patch-$(LFS_PATCH_VERSION).tar.xz)
LFS_PATCH_SRC_DIR = $(abspath src/patch-$(LFS_PATCH_VERSION))

.PHONY: \
patch-extract-src \
patch-build-p1 \
patch-build \
patch-clean

patch-extract-src:
	rm -rf "$(LFS_PATCH_SRC_DIR)"
	tar -xvf "$(LFS_PATCH_SRC_TAR)" -C src/

patch-build-p1:
	$(MAKE) patch-extract-src
	cd "$(LFS_PATCH_SRC_DIR)" && \
		./configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install
	rm -rf "$(LFS_PATCH_SRC_DIR)"

patch-build:
	$(MAKE) patch-extract-src
	cd "$(LFS_PATCH_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_PATCH_SRC_DIR)"

patch-clean:
	rm -rf "$(LFS_PATCH_SRC_DIR)"
