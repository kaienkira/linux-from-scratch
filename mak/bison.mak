LFS_BISON_VERSION = 3.8.2
LFS_BISON_SRC_TAR = $(abspath src/bison-$(LFS_BISON_VERSION).tar.xz)
LFS_BISON_SRC_DIR = $(abspath src/bison-$(LFS_BISON_VERSION))

.PHONY: \
bison-extract-src \
bison-build-chroot-p1 \
bison-clean

bison-extract-src:
	rm -rf "$(LFS_BISON_SRC_DIR)"
	tar -xvf "$(LFS_BISON_SRC_TAR)" -C src/

bison-build-chroot-p1:
	$(MAKE) bison-extract-src
	cd "$(LFS_BISON_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_BISON_SRC_DIR)"

bison-clean:
	rm -rf "$(LFS_BISON_SRC_DIR)"
