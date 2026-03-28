LFS_LIBFFI_VERSION = 3.5.2
LFS_LIBFFI_SRC_TAR = $(abspath src/libffi-$(LFS_LIBFFI_VERSION).tar.gz)
LFS_LIBFFI_SRC_DIR = $(abspath src/libffi-$(LFS_LIBFFI_VERSION))

.PHONY: \
libffi-extract-src \
libffi-build \
libffi-clean

libffi-extract-src:
	rm -rf "$(LFS_LIBFFI_SRC_DIR)"
	tar -xvf "$(LFS_LIBFFI_SRC_TAR)" -C src/

libffi-build:
	$(MAKE) libffi-extract-src
	cd "$(LFS_LIBFFI_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--disable-static \
			--with-gcc-arch=native \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_LIBFFI_SRC_DIR)"

libffi-clean:
	rm -rf "$(LFS_LIBFFI_SRC_DIR)"
