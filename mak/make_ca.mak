LFS_MAKE_CA_VERSION = 1.16.1
LFS_MAKE_CA_SRC_TAR = $(abspath src/make_ca-$(LFS_MAKE_CA_VERSION).tar.gz)
LFS_MAKE_CA_SRC_DIR = $(abspath src/make-ca-$(LFS_MAKE_CA_VERSION))

.PHONY: \
make-ca-extract-src \
make-ca-build \
make-ca-clean

make-ca-extract-src:
	rm -rf "$(LFS_MAKE_CA_SRC_DIR)"
	tar -xvf "$(LFS_MAKE_CA_SRC_TAR)" -C src/
	cd "$(LFS_MAKE_CA_SRC_DIR)" && \
		sed '/mktemp/s/-t //' -i make-ca

make-ca-build:
	$(MAKE) make-ca-extract-src
	cd "$(LFS_MAKE_CA_SRC_DIR)" && \
		make install && \
		install -vdm755 /etc/ssl/local
	rm -rf "$(LFS_MAKE_CA_SRC_DIR)"

make-ca-clean:
	rm -rf "$(LFS_MAKE_CA_SRC_DIR)"
