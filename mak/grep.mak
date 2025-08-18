GREP_SRC_DIR = $(abspath src/grep-3.12)

.PHONY: \
grep-build \
grep-clean

grep-build:
	mkdir -p "$(GREP_SRC_DIR)"/build
	cd "$(GREP_SRC_DIR)"/build && \
		../configure \
			--build=$(LFS_COMPILE_BUILD) \
			--host=$(LFS_COMPILE_HOST) \
			--prefix=/usr \
			--disable-nls && \
		make -j$(NPROC) && \
		make DESTDIR="$(LFS_ROOT_DIR)" install

grep-clean:
	rm -rf "$(GREP_SRC_DIR)"/build
