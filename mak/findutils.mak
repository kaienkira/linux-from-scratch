LFS_FINDUTILS_VERSION = 4.10.0
LFS_FINDUTILS_SRC_TAR = $(abspath src/findutils-$(LFS_FINDUTILS_VERSION).tar.xz)
LFS_FINDUTILS_SRC_DIR = $(abspath src/findutils-$(LFS_FINDUTILS_VERSION))

.PHONY: \
findutils-extract-src \
findutils-build-p1 \
findutils-build \
findutils-clean

findutils-extract-src:
	rm -rf "$(LFS_FINDUTILS_SRC_DIR)"
	tar -xvf "$(LFS_FINDUTILS_SRC_TAR)" -C src/

findutils-build-p1:
	$(MAKE) findutils-extract-src
	cd "$(LFS_FINDUTILS_SRC_DIR)" && \
		./configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			--localstatedir=/var/lib/locate \
			&& \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install
	rm -rf "$(LFS_FINDUTILS_SRC_DIR)"

findutils-build:
	$(MAKE) findutils-extract-src
	cd "$(LFS_FINDUTILS_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--localstatedir=/var/lib/locate \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_FINDUTILS_SRC_DIR)"

findutils-clean:
	rm -rf "$(LFS_FINDUTILS_SRC_DIR)"
