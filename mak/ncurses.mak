NCURSES_SRC_DIR = $(abspath src/ncurses-6.5)

.PHONY: \
ncurses-build-p1 \
ncurses-clean

ncurses-build-p1:
	mkdir -p "$(NCURSES_SRC_DIR)"/build_p1
	cd "$(NCURSES_SRC_DIR)"/build_p1 && \
		../configure \
			CFLAGS="-std=gnu17" \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			--mandir=/usr/share/man \
			--enable-widec \
			--with-manpage-format=normal \
			--with-shared \
			--with-cxx-shared \
			--without-debug \
			--without-normal \
			--without-ada \
			--disable-stripping && \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install

ncurses-clean:
	rm -rf "$(NCURSES_SRC_DIR)"/build_p1
