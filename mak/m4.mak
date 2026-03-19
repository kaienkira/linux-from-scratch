LFS_M4_VERSION = 1.4.21
LFS_M4_SRC_TAR = $(abspath src/m4-$(LFS_M4_VERSION).tar.xz)
LFS_M4_SRC_DIR = $(abspath src/m4-$(LFS_M4_VERSION))

.PHONY: \
m4-extract-src \
m4-build-p1 \
m4-build \
m4-clean

m4-extract-src:
	rm -rf "$(LFS_M4_SRC_DIR)"
	tar -xvf "$(LFS_M4_SRC_TAR)" -C src/

m4-build-p1:
	$(MAKE) m4-extract-src
	cd "$(LFS_M4_SRC_DIR)" && \
		./configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install
	rm -rf "$(LFS_M4_SRC_DIR)"

m4-build:
	$(MAKE) m4-extract-src
	cd "$(LFS_M4_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_M4_SRC_DIR)"

m4-clean:
	rm -rf "$(LFS_M4_SRC_DIR)"
