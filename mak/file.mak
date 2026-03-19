LFS_FILE_VERSION = 5.47
LFS_FILE_SRC_TAR = $(abspath src/file-$(LFS_FILE_VERSION).tar.gz)
LFS_FILE_SRC_DIR = $(abspath src/file-$(LFS_FILE_VERSION))

.PHONY: \
file-extract-src \
file-build-p1 \
file-clean

file-extract-src:
	rm -rf "$(LFS_FILE_SRC_DIR)"
	tar -xvf "$(LFS_FILE_SRC_TAR)" -C src/

file-build-p1:
	$(MAKE) file-extract-src
	mkdir -p "$(LFS_FILE_SRC_DIR)"/build_host
	cd "$(LFS_FILE_SRC_DIR)"/build_host && \
		../configure \
			--disable-bzlib \
			--disable-libseccomp \
			--disable-xzlib \
			--disable-zlib && \
		make -j$(NPROC)
	mkdir -p "$(LFS_FILE_SRC_DIR)"/build
	cd "$(LFS_FILE_SRC_DIR)"/build && \
		../configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr && \
		make FILE_COMPILE="$(LFS_FILE_SRC_DIR)"/build_host/src/file -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install
	rm -f "$(LFS_ROOT_DIR)"/usr/lib/libmagic.la
	rm -rf "$(LFS_FILE_SRC_DIR)"

file-build:
	$(MAKE) file-extract-src
	cd "$(LFS_FILE_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_FILE_SRC_DIR)"

file-clean:
	rm -rf "$(LFS_FILE_SRC_DIR)"
