M4_SRC_DIR = $(abspath src/m4-1.4.20)

.PHONY: \
m4-build \
m4-clean

m4-build:
	mkdir -p "$(M4_SRC_DIR)"/build
	cd "$(M4_SRC_DIR)"/build && \
		../configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr && \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install

m4-clean:
	rm -rf "$(M4_SRC_DIR)"/build
