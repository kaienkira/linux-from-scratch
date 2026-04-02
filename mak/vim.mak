LFS_VIM_VERSION = 9.2.0280
LFS_VIM_SRC_TAR = $(abspath src/vim-$(LFS_VIM_VERSION).tar.gz)
LFS_VIM_SRC_DIR = $(abspath src/vim-$(LFS_VIM_VERSION))

.PHONY: \
vim-extract-src \
vim-build \
vim-clean

vim-extract-src:
	rm -rf "$(LFS_VIM_SRC_DIR)"
	tar -xvf "$(LFS_VIM_SRC_TAR)" -C src/
	cd "$(LFS_VIM_SRC_DIR)" && \
		echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h

vim-build:
	$(MAKE) vim-extract-src
	cd "$(LFS_VIM_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_VIM_SRC_DIR)"

vim-clean:
	rm -rf "$(LFS_VIM_SRC_DIR)"
