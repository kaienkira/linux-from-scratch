LINUX_SRC_DIR = $(abspath src/linux-6.15.9)

.PHONY: \
linux-build-headers-p1 \
linux-clean

linux-build-headers-p1:
	mkdir -p "$(LINUX_SRC_DIR)"/build_headers_p1
	cd "$(LINUX_SRC_DIR)" && \
		make O=build_headers_p1 headers
	find "$(LINUX_SRC_DIR)"/build_headers_p1/usr/include \
		-type f ! -name '*.h' -delete
	cp -r "$(LINUX_SRC_DIR)"/build_headers_p1/usr/include \
		"$(LFS_ROOT_DIR)"/usr/

linux-clean:
	rm -rf "$(LINUX_SRC_DIR)"/build_headers_p1
