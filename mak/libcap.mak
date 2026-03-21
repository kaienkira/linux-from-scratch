LFS_LIBCAP_VERSION = 2.77
LFS_LIBCAP_SRC_TAR = $(abspath src/libcap-$(LFS_LIBCAP_VERSION).tar.xz)
LFS_LIBCAP_SRC_DIR = $(abspath src/libcap-$(LFS_LIBCAP_VERSION))

.PHONY: \
libcap-extract-src \
libcap-build \
libcap-clean

libcap-extract-src:
	rm -rf "$(LFS_LIBCAP_SRC_DIR)"
	tar -xvf "$(LFS_LIBCAP_SRC_TAR)" -C src/
	cd "$(LFS_LIBCAP_SRC_DIR)" && \
		sed -i '/install -m.*STA/d' libcap/Makefile

libcap-build:
	$(MAKE) libcap-extract-src
	cd "$(LFS_LIBCAP_SRC_DIR)" && \
		make prefix=/usr lib=lib -j$(NPROC) && \
		make prefix=/usr lib=lib install
	rm -rf "$(LFS_LIBCAP_SRC_DIR)"

libcap-clean:
	rm -rf "$(LFS_LIBCAP_SRC_DIR)"
