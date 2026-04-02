LFS_TREE_VERSION = 2.3.2
LFS_TREE_SRC_TAR = $(abspath src/unix-tree-$(LFS_TREE_VERSION).tar.gz)
LFS_TREE_SRC_DIR = $(abspath src/unix-tree-$(LFS_TREE_VERSION))

.PHONY: \
tree-extract-src \
tree-build \
tree-clean

tree-extract-src:
	rm -rf "$(LFS_TREE_SRC_DIR)"
	tar -xvf "$(LFS_TREE_SRC_TAR)" -C src/

tree-build:
	$(MAKE) tree-extract-src
	cd "$(LFS_TREE_SRC_DIR)" && \
		make PREFIX=/usr -j$(NPROC) && \
		make PREFIX=/usr install
	rm -rf "$(LFS_TREE_SRC_DIR)"

tree-clean:
	rm -rf "$(LFS_TREE_SRC_DIR)"
