LFS_GIT_VERSION = 2.54.0
LFS_GIT_SRC_TAR = $(abspath src/git-$(LFS_GIT_VERSION).tar.xz)
LFS_GIT_SRC_DIR = $(abspath src/git-$(LFS_GIT_VERSION))

.PHONY: \
git-extract-src \
git-build \
git-clean

git-extract-src:
	rm -rf "$(LFS_GIT_SRC_DIR)"
	tar -xvf "$(LFS_GIT_SRC_TAR)" -C src/

git-build:
	$(MAKE) git-extract-src
	cd "$(LFS_GIT_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--with-gitconfig=/etc/gitconfig \
			--with-python=python3 \
			--with-libpcre2 \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_GIT_SRC_DIR)"

git-clean:
	rm -rf "$(LFS_GIT_SRC_DIR)"
