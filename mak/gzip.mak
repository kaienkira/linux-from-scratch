LFS_GZIP_VERSION = 1.14
LFS_GZIP_SRC_TAR = $(abspath src/gzip-$(LFS_GZIP_VERSION).tar.xz)
LFS_GZIP_SRC_DIR = $(abspath src/gzip-$(LFS_GZIP_VERSION))

.PHONY: \
gzip-extract-src \
gzip-build-p1 \
gzip-build \
gzip-clean

gzip-extract-src:
	rm -rf "$(LFS_GZIP_SRC_DIR)"
	tar -xvf "$(LFS_GZIP_SRC_TAR)" -C src/

gzip-build-p1:
	$(MAKE) gzip-extract-src
	cd "$(LFS_GZIP_SRC_DIR)" && \
		./configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install
	rm -rf "$(LFS_GZIP_SRC_DIR)"

gzip-build:
	$(MAKE) gzip-extract-src
	cd "$(LFS_GZIP_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_GZIP_SRC_DIR)"

gzip-clean:
	rm -rf "$(LFS_GZIP_SRC_DIR)"
