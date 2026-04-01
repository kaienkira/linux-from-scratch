LFS_ROOT_DIR = $(abspath lfs_root)
LFS_COMPILE_BUILD = x86_64-pc-linux-gnu
LFS_COMPILE_HOST = x86_64-lfs-linux-gnu
LFS_COMPILE_TARGET = x86_64-lfs-linux-gnu
SHELL = /bin/bash
NPROC = $(shell expr `nproc` - 1)

export PATH = $(LFS_ROOT_DIR)/tools/bin:$(shell echo $$PATH)

.PHONY: \
default \
download-source \
build \
clean \
create-lfs-root-dir \
clean-lfs-root-dir \
create-lfs-temp-tools \
clean-lfs-temp-tools \
copy-src-to-lfs-root \
copy-config-files \
chroot \
unchroot

default: download-source

download-source:
	bash tools/download_source.sh

build: \
create-lfs-root-dir \
create-lfs-temp-tools \
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
binutils-build-p2 \
gcc-build-p2 \
copy-src-to-lfs-root \
copy-config-files \
clean-lfs-temp-tools

clean: \
clean-lfs-root-dir \
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

create-lfs-root-dir:
	mkdir -p "$(LFS_ROOT_DIR)"
	mkdir -p "$(LFS_ROOT_DIR)"/boot
	mkdir -p "$(LFS_ROOT_DIR)"/etc
	mkdir -p "$(LFS_ROOT_DIR)"/home
	mkdir -p "$(LFS_ROOT_DIR)"/mnt
	mkdir -p "$(LFS_ROOT_DIR)"/opt/build
	mkdir -p "$(LFS_ROOT_DIR)"/opt/build/mak
	mkdir -p "$(LFS_ROOT_DIR)"/opt/build/src
	mkdir -p "$(LFS_ROOT_DIR)"/root
	mkdir -p "$(LFS_ROOT_DIR)"/usr
	mkdir -p "$(LFS_ROOT_DIR)"/usr/bin
	mkdir -p "$(LFS_ROOT_DIR)"/usr/include
	mkdir -p "$(LFS_ROOT_DIR)"/usr/lib
	mkdir -p "$(LFS_ROOT_DIR)"/var
	mkdir -p "$(LFS_ROOT_DIR)"/dev
	mkdir -p "$(LFS_ROOT_DIR)"/proc
	mkdir -p "$(LFS_ROOT_DIR)"/sys
	mkdir -p "$(LFS_ROOT_DIR)"/run
	install -d -m1777 "$(LFS_ROOT_DIR)"/tmp
	install -d -m1777 "$(LFS_ROOT_DIR)"/var/tmp
	cd "$(LFS_ROOT_DIR)" && \
		ln -sfn usr/bin bin && \
		ln -sfn usr/bin sbin && \
		ln -sfn usr/lib lib && \
		ln -sfn usr/lib lib64 && \
		ln -sfn /proc/self/mounts etc/mtab
	cd "$(LFS_ROOT_DIR)"/usr && \
		ln -sfn bin sbin && \
		ln -sfn lib lib64
	cd "$(LFS_ROOT_DIR)"/var && \
		ln -sfn ../run run && \
		ln -sfn ../run/lock lock

clean-lfs-root-dir:
	rm -rf "$(LFS_ROOT_DIR)"

create-lfs-temp-tools:
	mkdir -p "$(LFS_ROOT_DIR)"/tools

clean-lfs-temp-tools:
	rm -rf "$(LFS_ROOT_DIR)"/tools/

copy-src-to-lfs-root:
	cp -f Makefile-chroot.mak "$(LFS_ROOT_DIR)"/opt/build/Makefile
	cp -f mak/*.mak "$(LFS_ROOT_DIR)"/opt/build/mak/
	cp -f src/*.tar.* "$(LFS_ROOT_DIR)"/opt/build/src/
	cp -f src/*.patch "$(LFS_ROOT_DIR)"/opt/build/src/

copy-config-files:
	cp etc/hosts "$(LFS_ROOT_DIR)"/etc/hosts
	cp etc/passwd "$(LFS_ROOT_DIR)"/etc/passwd
	cp etc/group "$(LFS_ROOT_DIR)"/etc/group
	cp etc/ld.so.conf "$(LFS_ROOT_DIR)/etc/ld.so.conf"
	cp etc/nsswitch.conf "$(LFS_ROOT_DIR)"/etc/nsswitch.conf

chroot:
	@sudo echo "chroot"
	@sudo chown -R root:root $(LFS_ROOT_DIR)/{boot,etc,opt,root,usr,var}
	@sudo chown -h root:root $(LFS_ROOT_DIR)/{bin,lib,lib64,sbin}
	@sudo chown root:root $(LFS_ROOT_DIR)/{home,mnt,tmp}
	@sudo chown root:root $(LFS_ROOT_DIR)/{dev,proc,run,sys}
	@sudo mount -B /dev $(LFS_ROOT_DIR)/dev
	@sudo mount -t devpts -o gid=5,mode=0620 none $(LFS_ROOT_DIR)/dev/pts
	@sudo mount -t proc none $(LFS_ROOT_DIR)/proc
	@sudo mount -t sysfs none $(LFS_ROOT_DIR)/sys
	@sudo mount -t tmpfs none $(LFS_ROOT_DIR)/run
	@-sudo chroot $(LFS_ROOT_DIR) /usr/bin/env -i \
		HOME=/root \
		TERM="$(TERM)" \
		PS1='(chroot) \u:\w\$$ ' \
		PATH=/usr/bin \
		/bin/bash
	$(MAKE) unchroot

unchroot:
	@sudo echo "unchroot"
	@-sudo umount $(LFS_ROOT_DIR)/run
	@-sudo umount $(LFS_ROOT_DIR)/sys
	@-sudo umount $(LFS_ROOT_DIR)/proc
	@-sudo umount $(LFS_ROOT_DIR)/dev/pts
	@-sudo umount $(LFS_ROOT_DIR)/dev
	@sudo chown -R `id -un`:`id -g` $(LFS_ROOT_DIR)/{boot,etc,opt,root,usr,var}
	@sudo chown -h `id -un`:`id -g` $(LFS_ROOT_DIR)/{bin,lib,lib64,sbin}
	@sudo chown `id -un`:`id -g` $(LFS_ROOT_DIR)/{home,mnt,tmp}
	@sudo chown `id -un`:`id -g` $(LFS_ROOT_DIR)/{dev,proc,run,sys}

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
