LFS_ROOT_DIR = $(abspath lfs_root)
LFS_COMPILE_BUILD = x86_64-pc-linux-gnu
LFS_COMPILE_HOST = x86_64-lfs-linux-gnu
LFS_COMPILE_TARGET = x86_64-lfs-linux-gnu
NPROC = $(shell expr `nproc` - 1)

export PATH = $(LFS_ROOT_DIR)/tools/bin:$(shell echo $$PATH)

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
binutils-build-p1 \
gcc-build-p1 \
linux-build-headers-p1 \
glibc-build-p1

clean: \
clean_lfs_root_dir \
binutils-clean \
gcc-clean \
glibc-clean \
linux-clean

create_lfs_root_dir:
	mkdir -p "$(LFS_ROOT_DIR)"
	mkdir -p "$(LFS_ROOT_DIR)"/tools
	mkdir -p "$(LFS_ROOT_DIR)"/usr
	mkdir -p "$(LFS_ROOT_DIR)"/usr/bin
	mkdir -p "$(LFS_ROOT_DIR)"/usr/include
	mkdir -p "$(LFS_ROOT_DIR)"/usr/lib

clean_lfs_root_dir:
	rm -rf "$(LFS_ROOT_DIR)"

include mak/binutils.mak
include mak/gmp.mak
include mak/mpfr.mak
include mak/mpc.mak
include mak/gcc.mak
include mak/glibc.mak
include mak/linux.mak
