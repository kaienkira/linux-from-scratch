LFS_IPROUTE2_VERSION = 6.19.0
LFS_IPROUTE2_SRC_TAR = $(abspath src/iproute2-$(LFS_IPROUTE2_VERSION).tar.xz)
LFS_IPROUTE2_SRC_DIR = $(abspath src/iproute2-$(LFS_IPROUTE2_VERSION))

.PHONY: \
iproute2-extract-src \
iproute2-build \
iproute2-clean

iproute2-extract-src:
	rm -rf "$(LFS_IPROUTE2_SRC_DIR)"
	tar -xvf "$(LFS_IPROUTE2_SRC_TAR)" -C src/
	cd "$(LFS_IPROUTE2_SRC_DIR)" && \
		sed -i /ARPD/d Makefile && \
		rm -fv man/man8/arpd.8

iproute2-build:
	$(MAKE) iproute2-extract-src
	cd "$(LFS_IPROUTE2_SRC_DIR)" && \
		make NETNS_RUN_DIR=/run/netns -j$(NPROC) && \
		make SBINDIR=/usr/sbin install
	rm -rf "$(LFS_IPROUTE2_SRC_DIR)"

iproute2-clean:
	rm -rf "$(LFS_IPROUTE2_SRC_DIR)"
