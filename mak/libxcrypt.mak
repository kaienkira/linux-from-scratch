LFS_LIBCRYPT_VERSION = 4.5.2
LFS_LIBCRYPT_SRC_TAR = $(abspath src/libxcrypt-$(LFS_LIBCRYPT_VERSION).tar.xz)
LFS_LIBCRYPT_SRC_DIR = $(abspath src/libxcrypt-$(LFS_LIBCRYPT_VERSION))

.PHONY: \
libxcrypt-extract-src \
libxcrypt-build \
libxcrypt-clean

libxcrypt-extract-src:
	rm -rf "$(LFS_LIBCRYPT_SRC_DIR)"
	tar -xvf "$(LFS_LIBCRYPT_SRC_TAR)" -C src/
	cd "$(LFS_LIBCRYPT_SRC_DIR)" && \
		sed -i '/strchr/s/const//' lib/crypt-{sm3,gost}-yescrypt.c

libxcrypt-build:
	$(MAKE) libxcrypt-extract-src
	cd "$(LFS_LIBCRYPT_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--disable-failure-tokens \
			--disable-static \
			--enable-hashes=strong,glibc \
			--enable-obsolete-api=no \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_LIBCRYPT_SRC_DIR)"

libxcrypt-clean:
	rm -rf "$(LFS_LIBCRYPT_SRC_DIR)"
