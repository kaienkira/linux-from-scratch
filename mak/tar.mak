LFS_TAR_VERSION = 1.35
LFS_TAR_SRC_TAR = $(abspath src/tar-$(LFS_TAR_VERSION).tar.xz)
LFS_TAR_SRC_DIR = $(abspath src/tar-$(LFS_TAR_VERSION))

.PHONY: \
tar-extract-src \
tar-build-p1 \
tar-clean

tar-extract-src:
	rm -rf "$(LFS_TAR_SRC_DIR)"
	tar -xvf "$(LFS_TAR_SRC_TAR)" -C src/

tar-build-p1:
	$(MAKE) tar-extract-src
	mkdir -p "$(LFS_TAR_SRC_DIR)"/build
	cd "$(LFS_TAR_SRC_DIR)"/build && \
		../configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install
	rm -rf "$(LFS_TAR_SRC_DIR)"

tar-clean:
	rm -rf "$(LFS_TAR_SRC_DIR)"
