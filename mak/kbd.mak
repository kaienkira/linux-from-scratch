LFS_KBD_VERSION = 2.9.0
LFS_KBD_SRC_TAR = $(abspath src/kbd-$(LFS_KBD_VERSION).tar.xz)
LFS_KBD_SRC_DIR = $(abspath src/kbd-$(LFS_KBD_VERSION))

.PHONY: \
kbd-extract-src \
kbd-build \
kbd-clean

kbd-extract-src:
	rm -rf "$(LFS_KBD_SRC_DIR)"
	tar -xvf "$(LFS_KBD_SRC_TAR)" -C src/
	patch -d "$(LFS_KBD_SRC_DIR)" -N -p1 -i ../kbd-2.9.0-backspace-1.patch
	cd "$(LFS_KBD_SRC_DIR)" && \
		sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure && \
		sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

kbd-build:
	$(MAKE) kbd-extract-src
	cd "$(LFS_KBD_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--disable-vlock \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_KBD_SRC_DIR)"

kbd-clean:
	rm -rf "$(LFS_KBD_SRC_DIR)"
