FILE_SRC_DIR = $(abspath src/file-5.46)

.PHONY: \
file-build \
file-clean

file-build:
	mkdir -p "$(FILE_SRC_DIR)"/build_host
	cd "$(FILE_SRC_DIR)"/build_host && \
		../configure \
			--disable-bzlib \
			--disable-libseccomp \
			--disable-nls \
			--disable-xzlib \
			--disable-zlib && \
		make -j$(NPROC)
	mkdir -p "$(FILE_SRC_DIR)"/build
	cd "$(FILE_SRC_DIR)"/build && \
		../configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			--disable-nls && \
		make FILE_COMPILE="$(FILE_SRC_DIR)"/build_host/src/file -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install
	rm -f "$(LFS_ROOT_DIR)"/usr/lib/libmagic.la

file-clean:
	rm -rf "$(FILE_SRC_DIR)"/build_host
	rm -rf "$(FILE_SRC_DIR)"/build
