LFS_SQLITE_VERSION = autoconf-3510200
LFS_SQLITE_SRC_TAR = $(abspath src/sqlite-$(LFS_SQLITE_VERSION).tar.gz)
LFS_SQLITE_SRC_DIR = $(abspath src/sqlite-$(LFS_SQLITE_VERSION))

.PHONY: \
sqlite-extract-src \
sqlite-build \
sqlite-clean

sqlite-extract-src:
	rm -rf "$(LFS_SQLITE_SRC_DIR)"
	tar -xvf "$(LFS_SQLITE_SRC_TAR)" -C src/

sqlite-build:
	$(MAKE) sqlite-extract-src
	cd "$(LFS_SQLITE_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--disable-static \
			--enable-fts4 \
			--enable-fts5 \
			CPPFLAGS="\
				-D SQLITE_ENABLE_COLUMN_METADATA=1 \
				-D SQLITE_ENABLE_UNLOCK_NOTIFY=1 \
				-D SQLITE_ENABLE_DBSTAT_VTAB=1 \
				-D SQLITE_SECURE_DELETE=1" \
			&& \
		make LDFLAGS.rpath="" -j$(NPROC) && \
		make install
	rm -rf "$(LFS_SQLITE_SRC_DIR)"

sqlite-clean:
	rm -rf "$(LFS_SQLITE_SRC_DIR)"
