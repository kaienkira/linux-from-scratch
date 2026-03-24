LFS_NCURSES_VERSION = 6.6
LFS_NCURSES_SRC_TAR = $(abspath src/ncurses-$(LFS_NCURSES_VERSION).tar.gz)
LFS_NCURSES_SRC_DIR = $(abspath src/ncurses-$(LFS_NCURSES_VERSION))

.PHONY: \
ncurses-extract-src \
ncurses-build-p1 \
ncurses-build \
ncurses-clean

ncurses-extract-src:
	rm -rf "$(LFS_NCURSES_SRC_DIR)"
	tar -xvf "$(LFS_NCURSES_SRC_TAR)" -C src/

ncurses-build-p1:
	$(MAKE) ncurses-extract-src
	cd "$(LFS_NCURSES_SRC_DIR)" && \
		./configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			--disable-stripping \
			--mandir=/usr/share/man \
			--with-manpage-format=normal \
			--with-shared \
			--with-cxx-shared \
			--without-debug \
			--without-normal \
			--without-ada \
			AWK=gawk \
			&& \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install
	cd "$(LFS_ROOT_DIR)"/usr/lib && \
		ln -sf libncursesw.so libncurses.so
	rm -rf "$(LFS_NCURSES_SRC_DIR)"

ncurses-build:
	$(MAKE) ncurses-extract-src
	cd "$(LFS_NCURSES_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--mandir=/usr/share/man \
			--enable-pc-files \
			--with-cxx-shared \
			--with-pkg-config-libdir=/usr/lib/pkgconfig \
			--with-shared \
			--without-debug \
			--without-normal \
			&& \
		make -j$(NPROC) && \
		make install
	cd "$(LFS_ROOT_DIR)"/usr/lib && \
		ln -sf libncursesw.so libncurses.so && \
		ln -sf libformw.so libform.so && \
		ln -sf libpanelw.so libpanel.so && \
		ln -sf libmenuw.so libmenu.so && \
		ln -sf libncursesw.so libcurses.so
	cd "$(LFS_ROOT_DIR)"/usr/lib/pkgconfig && \
		ln -sf ncursesw.pc ncurses.pc && \
		ln -sf formw.pc form.pc && \
		ln -sf panelw.pc panel.pc && \
		ln -sf menuw.pc menu.pc
	rm -rf "$(LFS_NCURSES_SRC_DIR)"

ncurses-clean:
	rm -rf "$(LFS_NCURSES_SRC_DIR)"
