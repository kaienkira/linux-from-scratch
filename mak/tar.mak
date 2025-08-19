TAR_SRC_DIR = $(abspath src/tar-1.35)

.PHONY: \
tar-build \
tar-clean

tar-build:
	mkdir -p "$(TAR_SRC_DIR)"/build
	cd "$(TAR_SRC_DIR)"/build && \
		../configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			--sbindir=/usr/bin \
			--libexecdir=/usr/lib/tar \
			--disable-nls \
			--enable-backup-scripts && \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install

tar-clean:
	rm -rf "$(TAR_SRC_DIR)"/build
