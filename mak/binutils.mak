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

.PHONY: \
binutils-build-p1 \
binutils-clean

binutils-build-p1:
	mkdir -p "$(BINUTILS_SRC_DIR)"/build_p1
	cd "$(BINUTILS_SRC_DIR)"/build_p1 && \
		../configure \
			--target=$(LFS_COMPILE_TARGET) \
			--prefix="$(LFS_ROOT_DIR)"/tools \
			--with-sysroot="$(LFS_ROOT_DIR)" \
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
			--with-pic && \
		make -j$(NPROC) && \
		make install

binutils-clean:
	rm -rf "$(BINUTILS_SRC_DIR)"/build_p1
