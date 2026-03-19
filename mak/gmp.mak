LFS_GMP_VERSION = 6.3.0
LFS_GMP_SRC_TAR = $(abspath src/gmp-$(LFS_GMP_VERSION).tar.xz)
LFS_GMP_SRC_DIR = $(abspath src/gmp-$(LFS_GMP_VERSION))

.PHONY: \
gmp-extract-src \
gmp-build \
gmp-clean

gmp-extract-src:
	rm -rf "$(LFS_GMP_SRC_DIR)"
	tar -xvf "$(LFS_GMP_SRC_TAR)" -C src/
	cd "$(LFS_GMP_SRC_DIR)" && \
		sed -i '/long long t1;/,+1s/()/(...)/' configure

gmp-build:
	$(MAKE) gmp-extract-src
	cd "$(LFS_GMP_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--disable-static \
			--enable-cxx \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_GMP_SRC_DIR)"

gmp-clean:
	rm -rf "$(LFS_GMP_SRC_DIR)"
