XZ_SRC_DIR = $(abspath src/xz-5.8.1)

.PHONY: \
xz-build \
xz-clean

xz-build:
	mkdir -p "$(XZ_SRC_DIR)"/build
	cd "$(XZ_SRC_DIR)"/build && \
		../configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			--disable-nls \
			--disable-rpath && \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install

xz-clean:
	rm -rf "$(XZ_SRC_DIR)"/build
