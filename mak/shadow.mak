LFS_SHADOW_VERSION = 4.19.4
LFS_SHADOW_SRC_TAR = $(abspath src/shadow-$(LFS_SHADOW_VERSION).tar.xz)
LFS_SHADOW_SRC_DIR = $(abspath src/shadow-$(LFS_SHADOW_VERSION))

.PHONY: \
shadow-extract-src \
shadow-build \
shadow-clean

shadow-extract-src:
	rm -rf "$(LFS_SHADOW_SRC_DIR)"
	tar -xvf "$(LFS_SHADOW_SRC_TAR)" -C src/
	cd "$(LFS_SHADOW_SRC_DIR)" && \
		find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \; && \
		find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \; && \
		sed -e 's:/var/spool/mail:/var/mail:' \
			-e '/PATH=/{s@/sbin:@@;s@/bin:@@}' \
			-i etc/login.defs

shadow-build:
	$(MAKE) shadow-extract-src
	touch /usr/bin/passwd
	cd "$(LFS_SHADOW_SRC_DIR)" && \
		./configure \
			--sysconfdir=/etc \
			--disable-logind \
			--disable-static \
			--with-bcrypt \
			--with-group-name-max-length=32 \
			--with-yescrypt \
			--without-libbsd \
			&& \
		make -j$(NPROC) && \
		make exec_prefix=/usr install && \
		make -C man install-man
	pwconv
	grpconv
	mkdir -p /etc/default
	useradd -D --gid 999
	rm -rf "$(LFS_SHADOW_SRC_DIR)"

shadow-clean:
	rm -rf "$(LFS_SHADOW_SRC_DIR)"
