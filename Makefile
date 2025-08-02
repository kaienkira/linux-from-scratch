LFS_ROOT_DIR = $(abspath lfs_root)
LFS_TOOLS_DIR = $(abspath lfs_root/tools)
LFS_TARGET = x86_64-lfs-linux-gnu
NPROC = $(shell expr `nproc` - 1)

.PHONY: \
default \
download \
build \
clean \
create_lfs_root_dir \
clean_lfs_root_dir

default: build

download:
	bash tools/download_source.sh

build: \
create_lfs_root_dir \
binutils-compile

clean: \
clean_lfs_root_dir

create_lfs_root_dir:
	mkdir -p "$(LFS_ROOT_DIR)"
	mkdir -p "$(LFS_TOOLS_DIR)"

clean_lfs_root_dir:
	rm -rf "$(LFS_ROOT_DIR)"

include mak/binutils.mak
