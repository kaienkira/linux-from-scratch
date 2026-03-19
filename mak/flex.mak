LFS_FLEX_VERSION = 2.6.4
LFS_FLEX_SRC_TAR = $(abspath src/flex-$(LFS_FLEX_VERSION).tar.gz)
LFS_FLEX_SRC_DIR = $(abspath src/flex-$(LFS_FLEX_VERSION))

.PHONY: \
flex-extract-src \
flex-build \
flex-clean

flex-extract-src:
	rm -rf "$(LFS_FLEX_SRC_DIR)"
	tar -xvf "$(LFS_FLEX_SRC_TAR)" -C src/

flex-build:
	$(MAKE) flex-extract-src
	cd "$(LFS_FLEX_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--disable-static \
			&& \
		make -j$(NPROC) && \
		make install
	cd /usr/bin && \
		ln -sf flex lex
	rm -rf "$(LFS_FLEX_SRC_DIR)"

flex-clean:
	rm -rf "$(LFS_FLEX_SRC_DIR)"
