LFS_GLIBC_VERSION = 2.43
LFS_GLIBC_PATCH_VERSION = 2
LFS_GLIBC_SRC_TAR = $(abspath src/glibc-$(LFS_GLIBC_VERSION).tar.xz)
LFS_GLIBC_SRC_DIR = $(abspath src/glibc-$(LFS_GLIBC_VERSION))
LFS_GLIBC_PATCH_TAR = $(abspath src/glibc_patch-$(LFS_GLIBC_VERSION)-$(LFS_GLIBC_PATCH_VERSION).tar.xz)

# nscd -> Name Service Cache Daemon

.PHONY: \
glibc-extract-src \
glibc-build-p1 \
glibc-clean

glibc-extract-src:
	rm -rf "$(LFS_GLIBC_SRC_DIR)"
	tar -xvf "$(LFS_GLIBC_SRC_TAR)" -C src/
	tar -xvf "$(LFS_GLIBC_PATCH_TAR)" -C "$(LFS_GLIBC_SRC_DIR)"
	for f in `ls $(LFS_GLIBC_SRC_DIR)/patches/*.patch`; \
	do \
		patch -d "$(LFS_GLIBC_SRC_DIR)" -N -p1 -i $$f; \
		if [ $$? -ne 0 ]; then exit 1; fi; \
	done

glibc-build-p1:
	$(MAKE) glibc-extract-src
	mkdir -p "$(LFS_GLIBC_SRC_DIR)"/build
	cd "$(LFS_GLIBC_SRC_DIR)"/build && \
		echo "rootsbindir=/usr/bin" >> configparms && \
		../configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			--disable-nscd \
			--enable-kernel=6.18 \
			libc_cv_slibdir=/usr/lib && \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install
		sed '/RTLDLIST=/s@/usr@@g' -i $(LFS_ROOT_DIR)/usr/bin/ldd
	rm -rf "$(LFS_GLIBC_SRC_DIR)"

glibc-build:
	$(MAKE) glibc-extract-src
	mkdir -p "$(LFS_GLIBC_SRC_DIR)"/build
	cd "$(LFS_GLIBC_SRC_DIR)"/build && \
		echo "rootsbindir=/usr/bin" >> configparms && \
		../configure \
			--prefix=/usr \
			--disable-nscd \
			--disable-werror \
			--enable-kernel=6.18 \
			--enable-stack-protector=strong \
			libc_cv_slibdir=/usr/lib && \
		make -j$(NPROC) && \
		touch /etc/ld.so.conf && \
		sed '/test-installation/s@$$(PERL)@echo not running@' -i ../Makefile && \
		make install
		sed '/RTLDLIST=/s@/usr@@g' -i /usr/bin/ldd
		mkdir -p /usr/lib/locale
		localedef -i C -f UTF-8 C.UTF-8
		localedef -i en_US -f UTF-8 en_US.UTF-8
	rm -rf "$(LFS_GLIBC_SRC_DIR)"

glibc-clean:
	rm -rf "$(LFS_GLIBC_SRC_DIR)"
