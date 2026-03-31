LFS_UTIL_LINUX_VERSION = 2.41.3
LFS_UTIL_LINUX_SRC_TAR = $(abspath src/util-linux-$(LFS_UTIL_LINUX_VERSION).tar.xz)
LFS_UTIL_LINUX_SRC_DIR = $(abspath src/util-linux-$(LFS_UTIL_LINUX_VERSION))

.PHONY: \
util-linux-extract-src \
util-linux-build-chroot-p1 \
util-linux-clean

util-linux-extract-src:
	rm -rf "$(LFS_UTIL_LINUX_SRC_DIR)"
	tar -xvf "$(LFS_UTIL_LINUX_SRC_TAR)" -C src/

util-linux-build-chroot-p1:
	$(MAKE) util-linux-extract-src
	mkdir -p /var/lib/hwclock
	cd "$(LFS_UTIL_LINUX_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--libdir=/usr/lib \
			--runstatedir=/run \
			--disable-chfn-chsh \
			--disable-liblastlog2 \
			--disable-login \
			--disable-nologin \
			--disable-pylibmount \
			--disable-runuser \
			--disable-setpriv \
			--disable-static \
			--disable-su \
			--without-python \
			ADJTIME_PATH=/var/lib/hwclock/adjtime \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_UTIL_LINUX_SRC_DIR)"

util-linux-build:
	$(MAKE) util-linux-extract-src
	mkdir -p /var/lib/hwclock
	cd "$(LFS_UTIL_LINUX_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--libdir=/usr/lib \
			--runstatedir=/run \
			--disable-chfn-chsh \
			--disable-liblastlog2 \
			--disable-login \
			--disable-nologin \
			--disable-pylibmount \
			--disable-runuser \
			--disable-setpriv \
			--disable-static \
			--disable-su \
			--without-python \
			ADJTIME_PATH=/var/lib/hwclock/adjtime \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_UTIL_LINUX_SRC_DIR)"

util-linux-clean:
	rm -rf "$(LFS_UTIL_LINUX_SRC_DIR)"
