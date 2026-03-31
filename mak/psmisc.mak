LFS_PSMISC_VERSION = 23.7
LFS_PSMISC_SRC_TAR = $(abspath src/psmisc-$(LFS_PSMISC_VERSION).tar.xz)
LFS_PSMISC_SRC_DIR = $(abspath src/psmisc-$(LFS_PSMISC_VERSION))

.PHONY: \
psmisc-extract-src \
psmisc-build \
psmisc-clean

psmisc-extract-src:
	rm -rf "$(LFS_PSMISC_SRC_DIR)"
	tar -xvf "$(LFS_PSMISC_SRC_TAR)" -C src/

psmisc-build:
	$(MAKE) psmisc-extract-src
	cd "$(LFS_PSMISC_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		rm -f /usr/bin/pstree.x11 && \
		make install
	rm -rf "$(LFS_PSMISC_SRC_DIR)"

psmisc-clean:
	rm -rf "$(LFS_PSMISC_SRC_DIR)"
