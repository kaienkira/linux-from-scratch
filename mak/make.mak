LFS_MAKE_VERSION = 4.4.1
LFS_MAKE_SRC_TAR = $(abspath src/make-$(LFS_MAKE_VERSION).tar.gz)
LFS_MAKE_SRC_DIR = $(abspath src/make-$(LFS_MAKE_VERSION))

.PHONY: \
make-extract-src \
make-build-p1 \
make-build \
make-clean

make-extract-src:
	rm -rf "$(LFS_MAKE_SRC_DIR)"
	tar -xvf "$(LFS_MAKE_SRC_TAR)" -C src/

make-build-p1:
	$(MAKE) make-extract-src
	cd "$(LFS_MAKE_SRC_DIR)" && \
		./configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install
	rm -rf "$(LFS_MAKE_SRC_DIR)"

make-build:
	$(MAKE) make-extract-src
	cd "$(LFS_MAKE_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_MAKE_SRC_DIR)"

make-clean:
	rm -rf "$(LFS_MAKE_SRC_DIR)"
