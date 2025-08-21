BINUTILS_SRC_DIR = $(abspath src/binutils-2.45)

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

BINUTILS_COMMON_OPTS = \
--disable-nls \
--disable-werror \
--enable-cet \
--enable-colored-disassembly \
--enable-default-execstack=no \
--enable-deterministic-archives \
--enable-gold \
--enable-ld=default \
--enable-new-dtags \
--enable-plugins \
--enable-relro \
--enable-shared \
--enable-targets=x86_64-pep,bpf-unknown-none \
--enable-threads \
--with-debuginfod=no \
--with-pic

.PHONY: \
binutils-build-p1 \
binutils-build-p2 \
binutils-clean

binutils-build-p1:
	mkdir -p "$(BINUTILS_SRC_DIR)"/build_p1
	cd "$(BINUTILS_SRC_DIR)"/build_p1 && \
		../configure \
			--target=$(LFS_COMPILE_TARGET) \
			--prefix="$(LFS_ROOT_DIR)"/tools \
			--with-sysroot="$(LFS_ROOT_DIR)" \
			$(BINUTILS_COMMON_OPTS) && \
		make -j$(NPROC) && \
		make install

binutils-build-p2:
	mkdir -p "$(BINUTILS_SRC_DIR)"/build_p2
	cd "$(BINUTILS_SRC_DIR)"/build_p2 && \
		../configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			$(BINUTILS_COMMON_OPTS) && \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install
	rm -f "$(LFS_ROOT_DIR)"/usr/lib/libbfd.{a,la}
	rm -f "$(LFS_ROOT_DIR)"/usr/lib/libctf.{a,la}
	rm -f "$(LFS_ROOT_DIR)"/usr/lib/libctf-nobfd.{a,la}
	rm -f "$(LFS_ROOT_DIR)"/usr/lib/libgprofng.{a,la}
	rm -f "$(LFS_ROOT_DIR)"/usr/lib/libopcodes.{a,la}
	rm -f "$(LFS_ROOT_DIR)"/usr/lib/libsframe.{a,la}

binutils-clean:
	rm -rf "$(BINUTILS_SRC_DIR)"/build_p1
	rm -rf "$(BINUTILS_SRC_DIR)"/build_p2
