LFS_DIFFUTILS_VERSION = 3.12
LFS_DIFFUTILS_SRC_TAR = $(abspath src/diffutils-$(LFS_DIFFUTILS_VERSION).tar.xz)
LFS_DIFFUTILS_SRC_DIR = $(abspath src/diffutils-$(LFS_DIFFUTILS_VERSION))

.PHONY: \
diffutils-extract-src \
diffutils-build-p1 \
diffutils-build \
diffutils-clean

diffutils-extract-src:
	rm -rf "$(LFS_DIFFUTILS_SRC_DIR)"
	tar -xvf "$(LFS_DIFFUTILS_SRC_TAR)" -C src/

diffutils-build-p1:
	$(MAKE) diffutils-extract-src
	cd "$(LFS_DIFFUTILS_SRC_DIR)" && \
		./configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			gl_cv_func_strcasecmp_works=y && \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install
	rm -rf "$(LFS_DIFFUTILS_SRC_DIR)"

diffutils-build:
	$(MAKE) diffutils-extract-src
	cd "$(LFS_DIFFUTILS_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_DIFFUTILS_SRC_DIR)"

diffutils-clean:
	rm -rf "$(LFS_DIFFUTILS_SRC_DIR)"
