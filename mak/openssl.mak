LFS_OPENSSL_VERSION = 3.6.1
LFS_OPENSSL_SRC_TAR = $(abspath src/openssl-$(LFS_OPENSSL_VERSION).tar.gz)
LFS_OPENSSL_SRC_DIR = $(abspath src/openssl-$(LFS_OPENSSL_VERSION))

.PHONY: \
openssl-extract-src \
openssl-build \
openssl-clean

openssl-extract-src:
	rm -rf "$(LFS_OPENSSL_SRC_DIR)"
	tar -xvf "$(LFS_OPENSSL_SRC_TAR)" -C src/

openssl-build:
	$(MAKE) openssl-extract-src
	cd "$(LFS_OPENSSL_SRC_DIR)" && \
		./config \
			--prefix=/usr \
			--openssldir=/etc/ssl \
			--libdir=lib \
			shared \
			zlib-dynamic \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_OPENSSL_SRC_DIR)"

openssl-clean:
	rm -rf "$(LFS_OPENSSL_SRC_DIR)"
