LFS_MPFR_VERSION = 4.2.2
LFS_MPFR_SRC_TAR = $(abspath src/mpfr-$(LFS_MPFR_VERSION).tar.xz)
LFS_MPFR_SRC_DIR = $(abspath src/mpfr-$(LFS_MPFR_VERSION))

.PHONY: \
mpfr-extract-src \
mpfr-build \
mpfr-clean

mpfr-extract-src:
	rm -rf "$(LFS_MPFR_SRC_DIR)"
	tar -xvf "$(LFS_MPFR_SRC_TAR)" -C src/

mpfr-build:
	$(MAKE) mpfr-extract-src
	cd "$(LFS_MPFR_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--disable-static \
			--enable-thread-safe \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_MPFR_SRC_DIR)"

mpfr-clean:
	rm -rf "$(LFS_MPFR_SRC_DIR)"
