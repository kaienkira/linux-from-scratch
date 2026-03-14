LFS_PYTHON_VERSION = 3.14.3
LFS_PYTHON_SRC_TAR = $(abspath src/Python-$(LFS_PYTHON_VERSION).tar.xz)
LFS_PYTHON_SRC_DIR = $(abspath src/Python-$(LFS_PYTHON_VERSION))

.PHONY: \
python-extract-src \
python-build-chroot-p1 \
python-clean

python-extract-src:
	rm -rf "$(LFS_PYTHON_SRC_DIR)"
	tar -xvf "$(LFS_PYTHON_SRC_TAR)" -C src/

python-build-chroot-p1:
	$(MAKE) python-extract-src
	cd "$(LFS_PYTHON_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--enable-shared \
			--without-ensurepip \
			--without-static-libpython \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_PYTHON_SRC_DIR)"

python-clean:
	rm -rf "$(LFS_PYTHON_SRC_DIR)"
