LFS_AUTOMAKE_VERSION = 1.18
LFS_AUTOMAKE_SRC_TAR = $(abspath src/automake-$(LFS_AUTOMAKE_VERSION).tar.xz)
LFS_AUTOMAKE_SRC_DIR = $(abspath src/automake-$(LFS_AUTOMAKE_VERSION))

.PHONY: \
automake-extract-src \
automake-build \
automake-clean

automake-extract-src:
	rm -rf "$(LFS_AUTOMAKE_SRC_DIR)"
	tar -xvf "$(LFS_AUTOMAKE_SRC_TAR)" -C src/

automake-build:
	$(MAKE) automake-extract-src
	cd "$(LFS_AUTOMAKE_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_AUTOMAKE_SRC_DIR)"

automake-clean:
	rm -rf "$(LFS_AUTOMAKE_SRC_DIR)"
