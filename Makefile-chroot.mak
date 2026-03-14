.PHONY: \
default \
build \
clean

default:

build: \
gettext-build-chroot-p1 \
bison-build-chroot-p1

clean: \
gettext-clean \
bison-clean

include mak/gettext.mak
include mak/bison.mak
