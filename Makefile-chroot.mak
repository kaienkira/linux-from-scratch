.PHONY: \
default \

default: build

build:

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
