GLIBC_VERSION = 2.41
GLIBC_SRC_DIR = $(abspath src/glibc-$(GLIBC_VERSION))

# nscd -> Name Service Cache Daemon

.PHONY: \
glibc-build-p1

glibc-build-p1:
	mkdir -p "$(GLIBC_SRC_DIR)"/build_p1
	cd "$(GLIBC_SRC_DIR)"/build_p1 && \
		echo "slibdir=/usr/lib" >> configparms && \
		echo "rtlddir=/usr/lib" >> configparms && \
		echo "sbindir=/usr/bin" >> configparms && \
		echo "rootsbindir=/usr/bin" >> configparms && \
		../configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			--libdir=/usr/lib \
			--libexecdir=/usr/lib \
			--with-headers="$(LFS_ROOT_DIR)"/usr/include \
			--enable-kernel=6.15 \
			--disable-profile \
			--disable-build-nscd \
			--disable-nscd \
			--without-gd \
			--without-selinux \
			libc_cv_slibdir=/usr/lib && \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install

glibc-clean:
	rm -rf "$(GLIBC_SRC_DIR)"/build_p1
