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

sync_source: download_source extract_source touch_source_dir

download_source:
	bash tools/download_source.sh

extract_source:
	bash tools/extract_source.sh

force_extract_source:
	find src/ -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} \;
	bash tools/extract_source.sh

touch_source_dir:
	find src/ -mindepth 1 -maxdepth 1 -type d -exec touch {} \;

build: \
create_lfs_root_dir \
binutils-build-p1 \
gcc-build-p1 \
linux-build-headers \
glibc-build \
gcc-build-libstdcxx \
m4-build \
ncurses-build \
bash-build \
coreutils-build \
diffutils-build \
file-build \
findutils-build \
gawk-build \
grep-build \
make-build \
patch-build \
sed-build \
tar-build

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
make-clean \
patch-clean \
sed-clean \
tar-clean

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
include mak/make.mak
include mak/patch.mak
include mak/sed.mak
include mak/tar.mak
