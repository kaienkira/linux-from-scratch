SED_SRC_DIR = $(abspath src/sed-4.9)

.PHONY: \
sed-build \
sed-clean

sed-build:
	mkdir -p "$(SED_SRC_DIR)"/build
	cd "$(SED_SRC_DIR)"/build && \
		../configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			--disable-nls && \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install

sed-clean:
	rm -rf "$(SED_SRC_DIR)"/build
