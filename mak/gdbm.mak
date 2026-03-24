LFS_GDBM_VERSION = 1.26
LFS_GDBM_SRC_TAR = $(abspath src/gdbm-$(LFS_GDBM_VERSION).tar.gz)
LFS_GDBM_SRC_DIR = $(abspath src/gdbm-$(LFS_GDBM_VERSION))

.PHONY: \
gdbm-extract-src \
gdbm-build \
gdbm-clean

gdbm-extract-src:
	rm -rf "$(LFS_GDBM_SRC_DIR)"
	tar -xvf "$(LFS_GDBM_SRC_TAR)" -C src/

gdbm-build:
	$(MAKE) gdbm-extract-src
	cd "$(LFS_GDBM_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--disable-static \
			--enable-libgdbm-compat \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_GDBM_SRC_DIR)"

gdbm-clean:
	rm -rf "$(LFS_GDBM_SRC_DIR)"
