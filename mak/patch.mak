PATCH_SRC_DIR = $(abspath src/patch-2.8)

.PHONY: \
patch-build \
patch-clean

patch-build:
	mkdir -p "$(PATCH_SRC_DIR)"/build
	cd "$(PATCH_SRC_DIR)"/build && \
		../configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			--disable-nls && \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install

patch-clean:
	rm -rf "$(PATCH_SRC_DIR)"/build
