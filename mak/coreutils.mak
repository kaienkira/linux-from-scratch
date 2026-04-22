LFS_COREUTILS_VERSION = 9.11
LFS_COREUTILS_SRC_TAR = $(abspath src/coreutils-$(LFS_COREUTILS_VERSION).tar.xz)
LFS_COREUTILS_SRC_DIR = $(abspath src/coreutils-$(LFS_COREUTILS_VERSION))

.PHONY: \
coreutils-extract-src \
coreutils-build-p1 \
coreutils-build \
coreutils-clean

coreutils-extract-src:
	rm -rf "$(LFS_COREUTILS_SRC_DIR)"
	tar -xvf "$(LFS_COREUTILS_SRC_TAR)" -C src/

coreutils-build-p1:
	$(MAKE) coreutils-extract-src
	cd "$(LFS_COREUTILS_SRC_DIR)" && \
		./configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			--enable-no-install-program=kill,uptime && \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install
	rm -rf "$(LFS_COREUTILS_SRC_DIR)"

coreutils-build:
	$(MAKE) coreutils-extract-src
	cd "$(LFS_COREUTILS_SRC_DIR)" && \
		FORCE_UNSAFE_CONFIGURE=1 ./configure \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_COREUTILS_SRC_DIR)"

coreutils-clean:
	rm -rf "$(LFS_COREUTILS_SRC_DIR)"
