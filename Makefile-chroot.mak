NPROC = $(shell expr `nproc` - 1)

.PHONY: \
default \
build \
clean \
clean-p1-temp-files

default:

build: \
gettext-build-chroot-p1 \
bison-build-chroot-p1 \
perl-build-chroot-p1 \
python-build-chroot-p1 \
texinfo-build-chroot-p1 \
util-linux-build-chroot-p1 \
clean-p1-temp-files \
build-world

build-world: \
man-pages-build \
iana-etc-build \
glibc-build \
tzdata-build \
zlib-build \
bzip2-build \
xz-build \
lz4-build \
zstd-build \
file-build \
readline-build \
pcre2-build \
m4-build \
bc-build \
flex-build \
pkgconf-build \
binutils-build \
gmp-build \
mpfr-build \
mpc-build \
attr-build \
acl-build \
libcap-build \
libxcrypt-build \
shadow-build \
gcc-build \
ncurses-build \
sed-build \
psmisc-build \
gettext-build \
bison-build \
grep-build \
bash-build \
libtool-build \
gdbm-build

clean: \
perl-clean \
python-clean \
texinfo-clean \
util-linux-clean \
man-pages-clean \
iana-etc-clean \
glibc-clean \
tzdata-clean \
zlib-clean \
bzip2-clean \
xz-clean \
lz4-clean \
zstd-clean \
file-clean \
readline-clean \
pcre2-clean \
m4-clean \
bc-clean \
flex-clean \
pkgconf-clean \
binutils-clean \
gmp-clean \
mpfr-clean \
mpc-clean \
attr-clean \
acl-clean \
libcap-clean \
libxcrypt-clean \
shadow-clean \
gcc-clean \
ncurses-clean \
sed-clean \
psmisc-clean \
gettext-clean \
bison-clean \
grep-clean \
bash-clean \
libtool-clean \
gdbm-clean

clean-p1-temp-files:
	rm -rf /usr/share/{doc,info,man}/*
	find /usr/{lib,libexec} -name "*.la" -delete

include mak/perl.mak
include mak/python.mak
include mak/texinfo.mak
include mak/util_linux.mak
include mak/man_pages.mak
include mak/iana_etc.mak
include mak/glibc.mak
include mak/tzdata.mak
include mak/zlib.mak
include mak/bzip2.mak
include mak/xz.mak
include mak/lz4.mak
include mak/zstd.mak
include mak/file.mak
include mak/readline.mak
include mak/pcre2.mak
include mak/m4.mak
include mak/bc.mak
include mak/flex.mak
include mak/pkgconf.mak
include mak/binutils.mak
include mak/gmp.mak
include mak/mpfr.mak
include mak/mpc.mak
include mak/attr.mak
include mak/acl.mak
include mak/libcap.mak
include mak/libxcrypt.mak
include mak/shadow.mak
include mak/gcc.mak
include mak/ncurses.mak
include mak/sed.mak
include mak/psmisc.mak
include mak/gettext.mak
include mak/bison.mak
include mak/grep.mak
include mak/bash.mak
include mak/libtool.mak
include mak/gdbm.mak
