.PHONY: \
default \
build \
clean

default:

build: \
gettext-build-chroot-p1 \
bison-build-chroot-p1 \
perl-build-chroot-p1 \
python-build-chroot-p1 \
texinfo-build-chroot-p1 \
util-linux-build-choot-p1

clean: \
gettext-clean \
bison-clean \
perl-clean \
python-clean \
texinfo-clean \
util-linux-clean

include mak/gettext.mak
include mak/bison.mak
include mak/perl.mak
include mak/python.mak
include mak/texinfo.mak
include mak/util_linux.mak
