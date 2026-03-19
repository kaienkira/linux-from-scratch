LFS_MPC_VERSION = 1.3.1
LFS_MPC_SRC_TAR = $(abspath src/mpc-$(LFS_MPC_VERSION).tar.gz)
LFS_MPC_SRC_DIR = $(abspath src/mpc-$(LFS_MPC_VERSION))

.PHONY: \
mpc-extract-src \
mpc-build \
mpc-clean

mpc-extract-src:
	rm -rf "$(LFS_MPC_SRC_DIR)"
	tar -xvf "$(LFS_MPC_SRC_TAR)" -C src/

mpc-build:
	$(MAKE) mpc-extract-src
	cd "$(LFS_MPC_SRC_DIR)" && \
		./configure \
			--prefix=/usr \
			--disable-static \
			&& \
		make -j$(NPROC) && \
		make install
	rm -rf "$(LFS_MPC_SRC_DIR)"

mpc-clean:
	rm -rf "$(LFS_MPC_SRC_DIR)"
