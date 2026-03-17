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
tzdata-build

clean: \
gettext-clean \
bison-clean \
perl-clean \
python-clean \
texinfo-clean \
util-linux-clean \
man-pages-clean \
iana-etc-clean \
glibc-clean

clean-p1-temp-files:
	rm -rf /usr/share/{doc,info,man}/*
	find /usr/{lib,libexec} -name "*.la" -delete

include mak/gettext.mak
include mak/bison.mak
include mak/perl.mak
include mak/python.mak
include mak/texinfo.mak
include mak/util_linux.mak
include mak/man_pages.mak
include mak/iana_etc.mak
include mak/glibc.mak
include mak/tzdata.mak
