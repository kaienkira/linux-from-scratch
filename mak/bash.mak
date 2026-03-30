LFS_BASH_VERSION = 5.3
LFS_BASH_SRC_TAR = $(abspath src/bash-$(LFS_BASH_VERSION).tar.gz)
LFS_BASH_SRC_DIR = $(abspath src/bash-$(LFS_BASH_VERSION))

.PHONY: \
bash-extract-src \
bash-build-p1 \
bash-build \
bash-clean

bash-extract-src:
	rm -rf "$(LFS_BASH_SRC_DIR)"
	tar -xvf "$(LFS_BASH_SRC_TAR)" -C src/

bash-build-p1:
	$(MAKE) bash-extract-src
	cd "$(LFS_BASH_SRC_DIR)" && \
		./configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			--without-bash-malloc && \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install
	cd "$(LFS_ROOT_DIR)"/usr/bin && \
		ln -sf bash sh
	rm -rf "$(LFS_BASH_SRC_DIR)"

bash-build:
	$(MAKE) bash-extract-src
	cd "$(LFS_BASH_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--with-installed-readline \
			--without-bash-malloc \
			&& \
		make -j$(NPROC) && \
		make install
	cd /usr/bin && \
		ln -sf bash sh
	rm -rf "$(LFS_BASH_SRC_DIR)"

bash-clean:
	rm -rf "$(LFS_BASH_SRC_DIR)"
