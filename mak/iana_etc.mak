LFS_IANA_ETC_VERSION = 20260310
LFS_IANA_ETC_SRC_TAR = $(abspath src/iana-etc-$(LFS_IANA_ETC_VERSION).tar.gz)
LFS_IANA_ETC_SRC_DIR = $(abspath src/iana-etc-$(LFS_IANA_ETC_VERSION))

.PHONY: \
iana-etc-extract-src \
iana-etc-build \
iana-etc-clean

iana-etc-extract-src:
	rm -rf "$(LFS_IANA_ETC_SRC_DIR)"
	tar -xvf "$(LFS_IANA_ETC_SRC_TAR)" -C src/

iana-etc-build:
	$(MAKE) iana-etc-extract-src
	cd "$(LFS_IANA_ETC_SRC_DIR)" && \
		cp -f services protocols /etc
	rm -rf "$(LFS_IANA_ETC_SRC_DIR)"

iana-etc-clean:
	rm -rf "$(LFS_IANA_ETC_SRC_DIR)"
