LFS_XZ_VERSION = 5.8.2
LFS_XZ_SRC_TAR = $(abspath src/xz-$(LFS_XZ_VERSION).tar.xz)
LFS_XZ_SRC_DIR = $(abspath src/xz-$(LFS_XZ_VERSION))

.PHONY: \
xz-extract-src \
xz-build-p1 \
xz-build \
xz-clean

xz-extract-src:
	rm -rf "$(LFS_XZ_SRC_DIR)"
	tar -xvf "$(LFS_XZ_SRC_TAR)" -C src/

xz-build-p1:
	$(MAKE) xz-extract-src
	cd "$(LFS_XZ_SRC_DIR)" && \
		./configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			--disable-static \
			&& \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install
	rm -f "$(LFS_ROOT_DIR)"/usr/lib/liblzma.la
	rm -rf "$(LFS_XZ_SRC_DIR)"

xz-build:
	$(MAKE) xz-extract-src
	cd "$(LFS_XZ_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--disable-static \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_XZ_SRC_DIR)"

xz-clean:
	rm -rf "$(LFS_XZ_SRC_DIR)"
