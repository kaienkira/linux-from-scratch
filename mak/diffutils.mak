DIFFUTILS_SRC_DIR = $(abspath src/diffutils-3.11)

.PHONY: \
diffutils-build \
diffutils-clean

diffutils-build:
	mkdir -p "$(DIFFUTILS_SRC_DIR)"/build
	cd "$(DIFFUTILS_SRC_DIR)"/build && \
		../configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			--disable-nls && \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install

diffutils-clean:
	rm -rf "$(DIFFUTILS_SRC_DIR)"/build
