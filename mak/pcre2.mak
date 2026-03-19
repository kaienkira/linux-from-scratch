LFS_PCRE2_VERSION = 10.47
LFS_PCRE2_SRC_TAR = $(abspath src/pcre2-$(LFS_PCRE2_VERSION).tar.gz)
LFS_PCRE2_SRC_DIR = $(abspath src/pcre2-$(LFS_PCRE2_VERSION))

.PHONY: \
pcre2-extract-src \
pcre2-build \
pcre2-clean

pcre2-extract-src:
	rm -rf "$(LFS_PCRE2_SRC_DIR)"
	tar -xvf "$(LFS_PCRE2_SRC_TAR)" -C src/

pcre2-build:
	$(MAKE) pcre2-extract-src
	cd "$(LFS_PCRE2_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--disable-static \
			--enable-jit \
			--enable-pcre2-16 \
			--enable-pcre2-32 \
			--enable-pcre2grep-libz \
			--enable-pcre2grep-libbz2 \
			--enable-pcre2test-libreadline \
			--enable-unicode \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_PCRE2_SRC_DIR)"

prce2-clean:
	rm -rf "$(LFS_PCRE2_SRC_DIR)"
