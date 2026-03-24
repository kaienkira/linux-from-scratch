LFS_SED_VERSION = 4.9
LFS_SED_SRC_TAR = $(abspath src/sed-$(LFS_SED_VERSION).tar.xz)
LFS_SED_SRC_DIR = $(abspath src/sed-$(LFS_SED_VERSION))

.PHONY: \
sed-extract-src \
sed-build-p1 \
sed-build \
sed-clean

sed-extract-src:
	rm -rf "$(LFS_SED_SRC_DIR)"
	tar -xvf "$(LFS_SED_SRC_TAR)" -C src/

sed-build-p1:
	$(MAKE) sed-extract-src
	cd "$(LFS_SED_SRC_DIR)" && \
		./configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install
	rm -rf "$(LFS_SED_SRC_DIR)"

sed-build:
	$(MAKE) sed-extract-src
	cd "$(LFS_SED_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_SED_SRC_DIR)"

sed-clean:
	rm -rf "$(LFS_SED_SRC_DIR)"
