LFS_PERL_VERSION = 5.42.0
LFS_PERL_SRC_TAR = $(abspath src/perl-$(LFS_PERL_VERSION).tar.xz)
LFS_PERL_SRC_DIR = $(abspath src/perl-$(LFS_PERL_VERSION))

.PHONY: \
perl-extract-src \
perl-build-chroot-p1 \
perl-build \
perl-clean

perl-extract-src:
	rm -rf "$(LFS_PERL_SRC_DIR)"
	tar -xvf "$(LFS_PERL_SRC_TAR)" -C src/

perl-build-chroot-p1:
	$(MAKE) perl-extract-src
	cd "$(LFS_PERL_SRC_DIR)" && \
		sh Configure -des \
			-D prefix=/usr \
			-D vendorprefix=/usr \
			-D useshrplib \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_PERL_SRC_DIR)"

perl-build:
	$(MAKE) perl-extract-src
	cd "$(LFS_PERL_SRC_DIR)" && \
		BUILD_ZLIB=False BUILD_BZIP2=0 \
		sh Configure -des \
			-D prefix=/usr \
			-D vendorprefix=/usr \
			-D pager="/usr/bin/less -isR" \
			-D useshrplib \
			-D usethreads \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_PERL_SRC_DIR)"

perl-clean:
	rm -rf "$(LFS_PERL_SRC_DIR)"
