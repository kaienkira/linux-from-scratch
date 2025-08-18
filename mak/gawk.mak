GAWK_SRC_DIR = $(abspath src/gawk-5.3.2)

.PHONY: \
gawk-build \
gawk-clean

gawk-build:
	mkdir -p "$(GAWK_SRC_DIR)"/build
	cd "$(GAWK_SRC_DIR)"/build && \
		../configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			--libexecdir=/usr/lib \
			--sysconfdir=/etc \
			--disable-nls \
			--without-libsigsegv && \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install

gawk-clean:
	rm -rf "$(GAWK_SRC_DIR)"/build
