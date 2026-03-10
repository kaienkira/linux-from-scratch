LFS_BASH_VERSION = 5.3
LFS_BASH_SRC_TAR = $(abspath src/bash-$(LFS_BASH_VERSION).tar.gz)
LFS_BASH_SRC_DIR = $(abspath src/bash-$(LFS_BASH_VERSION))

.PHONY: \
bash-extract-src \
bash-build-p1 \
bash-clean

bash-extract-src:
	rm -rf "$(LFS_BASH_SRC_DIR)"
	tar -xvf "$(LFS_BASH_SRC_TAR)" -C src/

bash-build-p1:
	$(MAKE) bash-extract-src
	mkdir -p "$(LFS_BASH_SRC_DIR)"/build
	cd "$(LFS_BASH_SRC_DIR)"/build && \
		../configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			--without-bash-malloc && \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install
	rm -rf "$(LFS_BASH_SRC_DIR)"

bash-clean:
	rm -rf "$(LFS_BASH_SRC_DIR)"
