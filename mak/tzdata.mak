LFS_TZDATA_VERSION = 2026a
LFS_TZDATA_SRC_TAR = $(abspath src/tzdata$(LFS_TZDATA_VERSION).tar.gz)
LFS_TZDATA_SRC_DIR = $(abspath src/tzdata-$(LFS_TZDATA_VERSION))

.PHONY: \
tzdata-extract-src \
tzdata-build \
tzdata-clean

tzdata-extract-src:
	rm -rf "$(LFS_TZDATA_SRC_DIR)"
	mkdir -p $(LFS_TZDATA_SRC_DIR)
	tar -xvf "$(LFS_TZDATA_SRC_TAR)" -C "$(LFS_TZDATA_SRC_DIR)"

tzdata-build:
	$(MAKE) tzdata-extract-src
	mkdir -p /usr/share/zoneinfo
	mkdir -p /usr/share/zoneinfo/posix
	mkdir -p /usr/share/zoneinfo/right
	cd "$(LFS_TZDATA_SRC_DIR)" && \
		for tz in \
			africa antarctica asia australasia \
			europe northamerica southamerica \
			etcetera backward; do \
			zic -L /dev/null -d /usr/share/zoneinfo "$${tz}" && \
			zic -L /dev/null -d /usr/share/zoneinfo/posix "$${tz}" && \
			zic -L leapseconds -d /usr/share/zoneinfo/right "$${tz}"; \
		done && \
		cp zone.tab zone1970.tab zonenow.tab /usr/share/zoneinfo
	ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
	rm -rf "$(LFS_TZDATA_SRC_DIR)"

tzdata-clean:
	rm -rf "$(LFS_TZDATA_SRC_DIR)"
