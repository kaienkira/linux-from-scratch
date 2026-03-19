LFS_BINUTILS_VERSION = 2.46.0
LFS_BINUTILS_SRC_TAR = $(abspath src/binutils-$(LFS_BINUTILS_VERSION).tar.xz)
LFS_BINUTILS_SRC_DIR = $(abspath src/binutils-$(LFS_BINUTILS_VERSION))

# cet -> Control-flow Enforcement Technology
# gold -> -fuse-ld=gold
# pgo -> Profile-Guided Optimization
#        -fprofile-generate -fprofile-use
# lto -> Link Time Optimization
#        -flto
# relro -> Relocation Read-Only
#          Partial RELRO  -z relro
#          Full RELRO     -z now
# x86_64-pep -> Portable Executable Plus(Win64 PE+)
# bpf-unknown-none -> eBPF

.PHONY: \
binutils-extract-src \
binutils-build-p1 \
binutils-build-p2 \
binutils-build \
binutils-clean

binutils-extract-src:
	rm -rf "$(LFS_BINUTILS_SRC_DIR)"
	tar -xvf "$(LFS_BINUTILS_SRC_TAR)" -C src/

binutils-build-p1:
	$(MAKE) binutils-extract-src
	mkdir -p "$(LFS_BINUTILS_SRC_DIR)"/build
	cd "$(LFS_BINUTILS_SRC_DIR)"/build && \
		../configure \
			--target=$(LFS_COMPILE_TARGET) \
			--prefix="$(LFS_ROOT_DIR)"/tools \
			--with-sysroot="$(LFS_ROOT_DIR)" \
			--disable-nls \
			--disable-werror \
			--enable-default-hash-style=gnu \
			--enable-gprofng=no \
			--enable-new-dtags \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_BINUTILS_SRC_DIR)"

binutils-build-p2:
	$(MAKE) binutils-extract-src
	cd "$(LFS_BINUTILS_SRC_DIR)" && \
		sed '6031s/$$add_dir//' -i ltmain.sh
	mkdir -p "$(LFS_BINUTILS_SRC_DIR)"/build
	cd "$(LFS_BINUTILS_SRC_DIR)"/build && \
		../configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			--disable-nls \
			--disable-werror \
			--enable-64-bit-bfd \
			--enable-default-hash-style=gnu \
			--enable-gprofng=no \
			--enable-new-dtags \
			--enable-shared \
			&& \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install
	rm -f "$(LFS_ROOT_DIR)"/usr/lib/libbfd.{a,la}
	rm -f "$(LFS_ROOT_DIR)"/usr/lib/libctf.{a,la}
	rm -f "$(LFS_ROOT_DIR)"/usr/lib/libctf-nobfd.{a,la}
	rm -f "$(LFS_ROOT_DIR)"/usr/lib/libopcodes.{a,la}
	rm -f "$(LFS_ROOT_DIR)"/usr/lib/libsframe.{a,la}
	rm -rf "$(LFS_BINUTILS_SRC_DIR)"

binutils-build:
	$(MAKE) binutils-extract-src
	mkdir -p "$(LFS_BINUTILS_SRC_DIR)"/build
	cd "$(LFS_BINUTILS_SRC_DIR)"/build && \
		../configure \
			--prefix=/usr \
			--sysconfdir=/etc \
			--disable-werror \
			--enable-64-bit-bfd \
			--enable-default-hash-style=gnu \
			--enable-ld=default \
			--enable-new-dtags \
			--enable-plugins \
			--enable-shared \
			--with-system-zlib \
			&& \
		make tooldir=/usr -j$(NPROC) && \
		make tooldir=/usr install
	rm -f /usr/lib/libbfd.a
	rm -f /usr/lib/libctf.a
	rm -f /usr/lib/libctf-nobfd.a
	rm -f /usr/lib/libgprofng.a
	rm -f /usr/lib/libopcodes.a
	rm -f /usr/lib/libsframe.a
	rm -rf /usr/share/doc/gprofng/
	rm -rf "$(LFS_BINUTILS_SRC_DIR)"

binutils-clean:
	rm -rf "$(LFS_BINUTILS_SRC_DIR)"
