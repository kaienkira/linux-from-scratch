MAKE_SRC_DIR = $(abspath src/make-4.4.1)

.PHONY: \
make-build \
make-clean

make-build:
	mkdir -p "$(MAKE_SRC_DIR)"/build
	cd "$(MAKE_SRC_DIR)"/build && \
		../configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			--disable-nls \
			--without-guile && \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install

make-clean:
	rm -rf "$(MAKE_SRC_DIR)"/build
