COREUTILS_SRC_DIR = $(abspath src/coreutils-9.7)

.PHONY: \
coreutils-build \
coreutils-clean

coreutils-build:
	mkdir -p "$(COREUTILS_SRC_DIR)"/build
	cd "$(COREUTILS_SRC_DIR)"/build && \
		../configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			--libexecdir=/usr/lib \
			--enable-no-install-program=hostname,kill,uptime && \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install

coreutils-clean:
	rm -rf "$(COREUTILS_SRC_DIR)"/build
