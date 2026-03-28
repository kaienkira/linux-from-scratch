LFS_GAWK_VERSION = 5.4.0
LFS_GAWK_SRC_TAR = $(abspath src/gawk-$(LFS_GAWK_VERSION).tar.xz)
LFS_GAWK_SRC_DIR = $(abspath src/gawk-$(LFS_GAWK_VERSION))

.PHONY: \
gawk-extract-src \
gawk-build-p1 \
gawk-build \
gawk-clean

gawk-extract-src:
	rm -rf "$(LFS_GAWK_SRC_DIR)"
	tar -xvf "$(LFS_GAWK_SRC_TAR)" -C src/
	cd "$(LFS_GAWK_SRC_DIR)" && \
		sed -i 's/extras//' Makefile.in

gawk-build-p1:
	$(MAKE) gawk-extract-src
	cd "$(LFS_GAWK_SRC_DIR)" && \
		./configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install
	rm -rf "$(LFS_GAWK_SRC_DIR)"

gawk-build:
	$(MAKE) gawk-extract-src
	cd "$(LFS_GAWK_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		rm -f /usr/bin/gawk-$(LFS_GAWK_VERSION) && \
		rm -f /usr/bin/awk && \
		make install
	rm -rf "$(LFS_GAWK_SRC_DIR)"

gawk-clean:
	rm -rf "$(LFS_GAWK_SRC_DIR)"
