LFS_LINUX_VERSION = 6.18.21
LFS_LINUX_SRC_TAR = $(abspath src/linux-$(LFS_LINUX_VERSION).tar.xz)
LFS_LINUX_SRC_DIR = $(abspath src/linux-$(LFS_LINUX_VERSION))

.PHONY: \
linux-extract-src \
linux-build-p1-headers \
linux-clean

linux-extract-src:
	rm -rf "$(LFS_LINUX_SRC_DIR)"
	tar -xvf "$(LFS_LINUX_SRC_TAR)" -C src/

linux-build-p1-headers:
	$(MAKE) linux-extract-src
	mkdir -p "$(LFS_LINUX_SRC_DIR)"/build
	cd "$(LFS_LINUX_SRC_DIR)" && \
		make O=build headers
	find "$(LFS_LINUX_SRC_DIR)"/build/usr/include \
		-type f ! -name '*.h' -delete
	cp -r "$(LFS_LINUX_SRC_DIR)"/build/usr/include/* \
		"$(LFS_ROOT_DIR)"/usr/include/
	rm -rf "$(LFS_LINUX_SRC_DIR)"

linux-clean:
	rm -rf "$(LFS_LINUX_SRC_DIR)"
