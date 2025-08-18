BASH_SRC_DIR = $(abspath src/bash-5.3)

.PHONY: \
bash-build \
bash-clean

bash-build:
	mkdir -p "$(BASH_SRC_DIR)"/build
	cd "$(BASH_SRC_DIR)"/build && \
		../configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			--disable-nls \
			--without-bash-malloc && \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install

bash-clean:
	rm -rf "$(BASH_SRC_DIR)"/build
