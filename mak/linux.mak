LINUX_SRC_DIR = $(abspath src/linux-6.17.9)

.PHONY: \
linux-build-headers \
linux-clean

linux-build-headers:
	mkdir -p "$(LINUX_SRC_DIR)"/build_headers
	cd "$(LINUX_SRC_DIR)" && \
		make O=build_headers headers
	find "$(LINUX_SRC_DIR)"/build_headers/usr/include \
		-type f ! -name '*.h' -delete
	cp -r "$(LINUX_SRC_DIR)"/build_headers/usr/include/* \
		"$(LFS_ROOT_DIR)"/usr/include/

linux-clean:
	rm -rf "$(LINUX_SRC_DIR)"/build_headers
