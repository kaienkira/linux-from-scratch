LFS_CURL_VERSION = 8.19.0
LFS_CURL_SRC_TAR = $(abspath src/curl-$(LFS_CURL_VERSION).tar.xz)
LFS_CURL_SRC_DIR = $(abspath src/curl-$(LFS_CURL_VERSION))

.PHONY: \
curl-extract-src \
curl-build \
curl-clean

curl-extract-src:
	rm -rf "$(LFS_CURL_SRC_DIR)"
	tar -xvf "$(LFS_CURL_SRC_TAR)" -C src/

curl-build:
	$(MAKE) curl-extract-src
	cd "$(LFS_CURL_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--disable-static \
			--with-openssl \
			--with-ca-path=/etc/ssl/certs \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_CURL_SRC_DIR)"

curl-clean:
	rm -rf "$(LFS_CURL_SRC_DIR)"
