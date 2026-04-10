LFS_PYTHON_VERSION = 3.14.3
LFS_PYTHON_SRC_TAR = $(abspath src/Python-$(LFS_PYTHON_VERSION).tar.xz)
LFS_PYTHON_SRC_DIR = $(abspath src/Python-$(LFS_PYTHON_VERSION))

LFS_PYTHON_FLIT_CORE_VERSION = 3.12.0
LFS_PYTHON_FLIT_CORE_SRC_TAR = $(abspath src/flit_core-$(LFS_PYTHON_FLIT_CORE_VERSION).tar.gz)
LFS_PYTHON_FLIT_CORE_SRC_DIR = $(abspath src/flit_core-$(LFS_PYTHON_FLIT_CORE_VERSION))

LFS_PYTHON_PACKAGING_VERSION = 26.0
LFS_PYTHON_PACKAGING_SRC_TAR = $(abspath src/packaging-$(LFS_PYTHON_PACKAGING_VERSION).tar.gz)
LFS_PYTHON_PACKAGING_SRC_DIR = $(abspath src/packaging-$(LFS_PYTHON_PACKAGING_VERSION))

LFS_PYTHON_WHEEL_VERSION = 0.46.3
LFS_PYTHON_WHEEL_SRC_TAR = $(abspath src/wheel-$(LFS_PYTHON_WHEEL_VERSION).tar.gz)
LFS_PYTHON_WHEEL_SRC_DIR = $(abspath src/wheel-$(LFS_PYTHON_WHEEL_VERSION))

LFS_PYTHON_SETUPTOOLS_VERSION = 82.0.1
LFS_PYTHON_SETUPTOOLS_SRC_TAR = $(abspath src/setuptools-$(LFS_PYTHON_SETUPTOOLS_VERSION).tar.gz)
LFS_PYTHON_SETUPTOOLS_SRC_DIR = $(abspath src/setuptools-$(LFS_PYTHON_SETUPTOOLS_VERSION))

LFS_PYTHON_MESON_VERSION = 1.10.2
LFS_PYTHON_MESON_SRC_TAR = $(abspath src/meson-$(LFS_PYTHON_MESON_VERSION).tar.gz)
LFS_PYTHON_MESON_SRC_DIR = $(abspath src/meson-$(LFS_PYTHON_MESON_VERSION))

.PHONY: \
python-extract-src \
python-build-chroot-p1 \
python-build \
python-flit-core-build \
python-packaging-build \
python-wheel-build \
python-setuptools-build \
python-meson-build \
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

python-build:
	$(MAKE) python-extract-src
	cd "$(LFS_PYTHON_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--enable-optimizations \
			--enable-shared \
			--with-system-expat \
			--without-static-libpython \
			&& \
		make -j$(NPROC) && \
		rm -f /usr/bin/pip3 && \
		rm -f /usr/bin/pip3.* && \
		make install
	rm -rf "$(LFS_PYTHON_SRC_DIR)"

python-flit-core-build:
	rm -rf "$(LFS_PYTHON_FLIT_CORE_SRC_DIR)"
	tar -xvf "$(LFS_PYTHON_FLIT_CORE_SRC_TAR)" -C src/
	cd "$(LFS_PYTHON_FLIT_CORE_SRC_DIR)" && \
		pip3 wheel -w dist \
			--no-build-isolation \
			--no-cache-dir \
			--no-deps $$PWD && \
		pip3 install --no-index --find-links dist flit_core
	rm -rf "$(LFS_PYTHON_FLIT_CORE_SRC_DIR)"

python-packaging-build:
	rm -rf "$(LFS_PYTHON_PACKAGING_SRC_DIR)"
	tar -xvf "$(LFS_PYTHON_PACKAGING_SRC_TAR)" -C src/
	cd "$(LFS_PYTHON_PACKAGING_SRC_DIR)" && \
		pip3 wheel -w dist \
			--no-build-isolation \
			--no-cache-dir \
			--no-deps $$PWD && \
		pip3 install --no-index --find-links dist packaging
	rm -rf "$(LFS_PYTHON_PACKAGING_SRC_DIR)"

python-wheel-build:
	rm -rf "$(LFS_PYTHON_WHEEL_SRC_DIR)"
	tar -xvf "$(LFS_PYTHON_WHEEL_SRC_TAR)" -C src/
	cd "$(LFS_PYTHON_WHEEL_SRC_DIR)" && \
		pip3 wheel -w dist \
			--no-build-isolation \
			--no-cache-dir \
			--no-deps $$PWD && \
		pip3 install --no-index --find-links dist wheel
	rm -rf "$(LFS_PYTHON_WHEEL_SRC_DIR)"

python-setuptools-build:
	rm -rf "$(LFS_PYTHON_SETUPTOOLS_SRC_DIR)"
	tar -xvf "$(LFS_PYTHON_SETUPTOOLS_SRC_TAR)" -C src/
	cd "$(LFS_PYTHON_SETUPTOOLS_SRC_DIR)" && \
		pip3 wheel -w dist \
			--no-build-isolation \
			--no-cache-dir \
			--no-deps $$PWD && \
		pip3 install --no-index --find-links dist setuptools
	rm -rf "$(LFS_PYTHON_SETUPTOOLS_SRC_DIR)"

python-meson-build:
	rm -rf "$(LFS_PYTHON_MESON_SRC_DIR)"
	tar -xvf "$(LFS_PYTHON_MESON_SRC_TAR)" -C src/
	cd "$(LFS_PYTHON_MESON_SRC_DIR)" && \
		pip3 wheel -w dist \
			--no-build-isolation \
			--no-cache-dir \
			--no-deps $$PWD && \
		pip3 install --no-index --find-links dist meson
	rm -rf "$(LFS_PYTHON_MESON_SRC_DIR)"

python-clean:
	rm -rf "$(LFS_PYTHON_SRC_DIR)"
	rm -rf "$(LFS_PYTHON_FLIT_CORE_SRC_DIR)"
	rm -rf "$(LFS_PYTHON_PACKAGING_SRC_DIR)"
	rm -rf "$(LFS_PYTHON_WHEEL_SRC_DIR)"
	rm -rf "$(LFS_PYTHON_SETUPTOOLS_SRC_DIR)"
	rm -rf "$(LFS_PYTHON_MESON_SRC_DIR)"
