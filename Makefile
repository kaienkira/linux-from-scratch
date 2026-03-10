LFS_ROOT_DIR = $(abspath lfs_root)
LFS_COMPILE_BUILD = x86_64-pc-linux-gnu
LFS_COMPILE_HOST = x86_64-lfs-linux-gnu
LFS_COMPILE_TARGET = x86_64-lfs-linux-gnu
NPROC = $(shell expr `nproc` - 1)

export PATH = $(LFS_ROOT_DIR)/tools/bin:$(shell echo $$PATH)

.PHONY: \
default \
sync_source \
download_source \
extract_source \
force_extract_source \
touch_source_dir \
build \
clean \
create_lfs_root_dir \
clean_lfs_root_dir \
chroot

default: build

download_source:
	bash tools/download_source.sh

build: \
create_lfs_root_dir \
binutils-build-p1 \
gcc-build-p1 \
linux-build-p1-headers \
glibc-build-p1 \
gcc-build-p1-libstdcxx \
m4-build-p1 \
ncurses-build-p1 \
bash-build-p1 \
coreutils-build-p1 \
diffutils-build-p1 \
file-build-p1 \
findutils-build-p1 \
gawk-build-p1 \
grep-build-p1 \
gzip-build-p1 \
make-build-p1 \
patch-build-p1 \
sed-build-p1 \
tar-build-p1 \
xz-build-p1 \
binutils-build-p2

clean: \
clean_lfs_root_dir \
binutils-clean \
gcc-clean \
glibc-clean \
linux-clean \
m4-clean \
ncurses-clean \
bash-clean \
coreutils-clean \
diffutils-clean \
file-clean \
findutils-clean \
gawk-clean \
grep-clean \
gzip-clean \
make-clean \
patch-clean \
sed-clean \
tar-clean \
xz-clean

create_lfs_root_dir:
	mkdir -p "$(LFS_ROOT_DIR)"
	mkdir -p "$(LFS_ROOT_DIR)"/tools
	mkdir -p "$(LFS_ROOT_DIR)"/usr
	mkdir -p "$(LFS_ROOT_DIR)"/usr/bin
	mkdir -p "$(LFS_ROOT_DIR)"/usr/include
	mkdir -p "$(LFS_ROOT_DIR)"/usr/lib
	cd "$(LFS_ROOT_DIR)" && \
		ln -sf usr/bin sbin && \
		ln -sf usr/bin bin && \
		ln -sf usr/lib lib && \
		ln -sf usr/lib lib64 && \
	cd "$(LFS_ROOT_DIR)"/usr && \
		ln -sf lib lib64

clean_lfs_root_dir:
	rm -rf "$(LFS_ROOT_DIR)"

chroot:
	sudo chroot $(LFS_ROOT_DIR) /bin/bash

include mak/binutils.mak
include mak/gmp.mak
include mak/mpfr.mak
include mak/mpc.mak
include mak/gcc.mak
include mak/glibc.mak
include mak/linux.mak
include mak/m4.mak
include mak/ncurses.mak
include mak/bash.mak
include mak/coreutils.mak
include mak/diffutils.mak
include mak/file.mak
include mak/findutils.mak
include mak/gawk.mak
include mak/grep.mak
include mak/gzip.mak
include mak/make.mak
include mak/patch.mak
include mak/sed.mak
include mak/tar.mak
include mak/xz.mak
