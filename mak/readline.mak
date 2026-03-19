LFS_READLINE_VERSION = 8.3
LFS_READLINE_SRC_TAR = $(abspath src/readline-$(LFS_READLINE_VERSION).tar.gz)
LFS_READLINE_SRC_DIR = $(abspath src/readline-$(LFS_READLINE_VERSION))

.PHONY: \
readline-extract-src \
readline-build \
readline-clean

readline-extract-src:
	rm -rf "$(LFS_READLINE_SRC_DIR)"
	tar -xvf "$(LFS_READLINE_SRC_TAR)" -C src/
	cd "$(LFS_READLINE_SRC_DIR)" && \
		sed -i '/MV.*old/d' Makefile.in && \
		sed -i '/{OLDSUFF}/c:' support/shlib-install && \
		sed -i 's/-Wl,-rpath,[^ ]*//' support/shobj-conf && \
		sed -e '270a\    else\n       chars_avail = 1;' \
			-e '288i\   result = -1;' \
			-i.orig input.c

readline-build:
	$(MAKE) readline-extract-src
	cd "$(LFS_READLINE_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--disable-static \
			--with-curses \
			&& \
		make SHLIB_LIBS="-lncursesw" -j$(NPROC) && \
		make install
	rm -rf "$(LFS_READLINE_SRC_DIR)"

realine-clean:
	rm -rf "$(LFS_READLINE_SRC_DIR)"
