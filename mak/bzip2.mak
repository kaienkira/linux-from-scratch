LFS_BZIP2_VERSION = 1.0.8
LFS_BZIP2_SRC_TAR = $(abspath src/bzip2-$(LFS_BZIP2_VERSION).tar.gz)
LFS_BZIP2_SRC_DIR = $(abspath src/bzip2-$(LFS_BZIP2_VERSION))

.PHONY: \
bzip2-extract-src \
bzip2-build \
bzip2-clean

bzip2-extract-src:
	rm -rf "$(LFS_BZIP2_SRC_DIR)"
	tar -xvf "$(LFS_BZIP2_SRC_TAR)" -C src/
	patch -d "$(LFS_BZIP2_SRC_DIR)" -N -p1 -i ../bzip2-1.0.8-install_docs-1.patch

bzip2-build:
	$(MAKE) bzip2-extract-src
	cd "$(LFS_BZIP2_SRC_DIR)" && \
		sed -i 's@\(ln -s -f \)$$(PREFIX)/bin/@\1@' Makefile && \
		sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile && \
		make -f Makefile-libbz2_so && \
		make clean && \
		make -j$(NPROC) && \
		make PREFIX=/usr install && \
		cp libbz2.so.* /usr/lib && \
		cp bzip2-shared /usr/bin/bzip2
	cd /usr/lib && \
		ln -sf libbz2.so.1.0.8 libbz2.so && \
		ln -sf libbz2.so.1.0.8 libbz2.so.1
	cd /usr/bin && \
		ln -sf bzip2 bzcat && \
		ln -sf bzip2 bunzip2
	rm -f /usr/lib/libbz2.a
	rm -rf "$(LFS_BZIP2_SRC_DIR)"

bzip2-clean:
	rm -rf "$(LFS_BZIP2_SRC_DIR)"
