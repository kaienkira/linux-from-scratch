LFS_GREP_VERSION = 3.12
LFS_GREP_SRC_TAR = $(abspath src/grep-$(LFS_GREP_VERSION).tar.xz)
LFS_GREP_SRC_DIR = $(abspath src/grep-$(LFS_GREP_VERSION))

.PHONY: \
grep-extract-src \
grep-build-p1 \
grep-build \
grep-clean

grep-extract-src:
	rm -rf "$(LFS_GREP_SRC_DIR)"
	tar -xvf "$(LFS_GREP_SRC_TAR)" -C src/

grep-build-p1:
	$(MAKE) grep-extract-src
	cd "$(LFS_GREP_SRC_DIR)" && \
		./configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install
	rm -rf "$(LFS_GREP_SRC_DIR)"

grep-build:
	$(MAKE) grep-extract-src
	cd "$(LFS_GREP_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_GREP_SRC_DIR)"

grep-clean:
	rm -rf "$(LFS_GREP_SRC_DIR)"
