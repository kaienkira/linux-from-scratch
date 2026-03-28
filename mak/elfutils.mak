LFS_ELFUTILS_VERSION = 0.194
LFS_ELFUTILS_SRC_TAR = $(abspath src/elfutils-$(LFS_ELFUTILS_VERSION).tar.bz2)
LFS_ELFUTILS_SRC_DIR = $(abspath src/elfutils-$(LFS_ELFUTILS_VERSION))

.PHONY: \
elfutils-extract-src \
elfutils-build \
elfutils-clean

elfutils-extract-src:
	rm -rf "$(LFS_ELFUTILS_SRC_DIR)"
	tar -xvf "$(LFS_ELFUTILS_SRC_TAR)" -C src/

elfutils-build:
	$(MAKE) elfutils-extract-src
	cd "$(LFS_ELFUTILS_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--disable-debuginfod \
			--enable-libdebuginfod=dummy \
			&& \
		make -C lib -j$(NPROC) && \
		make -C libelf -j$(NPROC) && \
		make -C libelf install && \
		install -vm644 config/libelf.pc /usr/lib/pkgconfig
	rm /usr/lib/libelf.a
	rm -rf "$(LFS_ELFUTILS_SRC_DIR)"

elfutils-clean:
	rm -rf "$(LFS_ELFUTILS_SRC_DIR)"
