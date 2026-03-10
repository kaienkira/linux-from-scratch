LFS_COREUTILS_VERSION = 9.10
LFS_COREUTILS_SRC_TAR = $(abspath src/coreutils-$(LFS_COREUTILS_VERSION).tar.xz)
LFS_COREUTILS_SRC_DIR = $(abspath src/coreutils-$(LFS_COREUTILS_VERSION))

.PHONY: \
coreutils-extract-src \
coreutils-build-p1 \
coreutils-clean

coreutils-extract-src:
	rm -rf "$(LFS_COREUTILS_SRC_DIR)"
	tar -xvf "$(LFS_COREUTILS_SRC_TAR)" -C src/

coreutils-build-p1:
	$(MAKE) coreutils-extract-src
	mkdir -p "$(LFS_COREUTILS_SRC_DIR)"/build
	cd "$(LFS_COREUTILS_SRC_DIR)"/build && \
		../configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			--enable-install-program=hostname \
			--enable-no-install-program=kill,uptime && \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install
	rm -rf "$(LFS_COREUTILS_SRC_DIR)"

coreutils-clean:
	rm -rf "$(LFS_COREUTILS_SRC_DIR)"
