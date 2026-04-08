LFS_NINJA_VERSION = 1.13.2
LFS_NINJA_SRC_TAR = $(abspath src/ninja-$(LFS_NINJA_VERSION).tar.gz)
LFS_NINJA_SRC_DIR = $(abspath src/ninja-$(LFS_NINJA_VERSION))

.PHONY: \
ninja-extract-src \
ninja-build \
ninja-clean

ninja-extract-src:
	rm -rf "$(LFS_NINJA_SRC_DIR)"
	tar -xvf "$(LFS_NINJA_SRC_TAR)" -C src/

ninja-build:
	$(MAKE) ninja-extract-src
	cd "$(LFS_NINJA_SRC_DIR)" && \
		python3 configure.py \
			--bootstrap \
			--verbose \
			&& \
		install -vm755 ninja /usr/bin/
	rm -rf "$(LFS_NINJA_SRC_DIR)"

ninja-clean:
	rm -rf "$(LFS_NINJA_SRC_DIR)"
