FINDUTILS_SRC_DIR = $(abspath src/findutils-4.10.0)

.PHONY: \
findutils-build \
findutils-clean

findutils-build:
	mkdir -p "$(FINDUTILS_SRC_DIR)"/build
	cd "$(FINDUTILS_SRC_DIR)"/build && \
		../configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			--localstatedir=/var/lib/locate \
			--disable-nls && \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install

findutils-clean:
	rm -rf "$(FINDUTILS_SRC_DIR)"/build
