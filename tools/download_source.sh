#!bin/bash

set -o pipefail

script_name=`basename "$0"`
script_abs_name=`readlink -f "$0"`
script_path=`dirname "$script_abs_name"`

src_dir=`readlink -f "$script_path"/../src`

cd "$src_dir"
if [ $? -ne 0 ]; then exit 1; fi

download_file()
{
    local url=$1
    local file_name=$2

    if [ -z "$file_name" ]
    then
        file_name=`basename "$url"`
    fi

    # file already exists
    if [ -f "$src_dir"/"$file_name" ]
    then
        return 0
    fi

    # delete old version file
    local package_name=${file_name%%-*}
    find "$src_dir" -maxdepth 1 -type f -name "${package_name}*" -delete

    echo "start download $url -> $file_name"
    curl -fSL -o "$file_name" "$url"
    if [ $? -ne 0 ]; then exit 1; fi

    return 0
}

download_patch()
{
    local url=$1
    local file_name=$2

    if [ -z "$file_name" ]
    then
        file_name=`basename "$url"`
    fi

    # file already exists
    if [ -f "$src_dir"/"$file_name" ]
    then
        return 0
    fi

    echo "start download $url -> $file_name"
    curl -fSL -o "$file_name" "$url"
    if [ $? -ne 0 ]; then exit 1; fi
}

download_file 'https://ftp.gnu.org/gnu/binutils/binutils-2.46.0.tar.xz'
download_file 'https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz'
download_file 'https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.2.tar.xz'
download_file 'https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz'
download_file 'https://ftp.gnu.org/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.xz'
download_file 'https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.18.21.tar.xz'
download_file 'https://ftp.gnu.org/gnu/glibc/glibc-2.43.tar.xz'
download_patch 'https://www.linuxfromscratch.org/patches/lfs/13.0/glibc-fhs-1.patch'
download_file 'https://ftp.gnu.org/gnu/m4/m4-1.4.21.tar.xz'
download_file 'https://ftp.gnu.org/gnu/ncurses/ncurses-6.6.tar.gz'
download_file 'https://ftp.gnu.org/gnu/bash/bash-5.3.tar.gz'
download_file 'https://ftp.gnu.org/gnu/coreutils/coreutils-9.10.tar.xz'
download_file 'https://ftp.gnu.org/gnu/diffutils/diffutils-3.12.tar.xz'
download_file 'https://astron.com/pub/file/file-5.47.tar.gz'
download_file 'https://ftp.gnu.org/gnu/findutils/findutils-4.10.0.tar.xz'
download_file 'https://ftp.gnu.org/gnu/gawk/gawk-5.4.0.tar.xz'
download_file 'https://ftp.gnu.org/gnu/grep/grep-3.12.tar.xz'
download_file 'https://ftp.gnu.org/gnu/gzip/gzip-1.14.tar.xz'
download_file 'https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz'
download_file 'https://ftp.gnu.org/gnu/patch/patch-2.8.tar.xz'
download_file 'https://ftp.gnu.org/gnu/sed/sed-4.9.tar.xz'
download_file 'https://ftp.gnu.org/gnu/tar/tar-1.35.tar.xz'
download_file 'https://github.com/tukaani-project/xz/releases/download/v5.8.2/xz-5.8.2.tar.xz'
download_file 'https://ftp.gnu.org/gnu/gettext/gettext-1.0.tar.xz'
download_file 'https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.xz'
download_file 'https://www.cpan.org/src/5.0/perl-5.42.0.tar.xz'
download_file 'https://www.python.org/ftp/python/3.14.3/Python-3.14.3.tar.xz'
download_file 'https://pypi.org/packages/source/f/flit-core/flit_core-3.12.0.tar.gz'
download_file 'https://pypi.org/packages/source/p/packaging/packaging-26.0.tar.gz'
download_file 'https://pypi.org/packages/source/w/wheel/wheel-0.46.3.tar.gz'
download_file 'https://pypi.org/packages/source/s/setuptools/setuptools-82.0.1.tar.gz'
download_file 'https://pypi.org/packages/source/M/MarkupSafe/markupsafe-3.0.3.tar.gz'
download_file 'https://pypi.org/packages/source/J/Jinja2/jinja2-3.1.6.tar.gz'
download_file 'https://github.com/ninja-build/ninja/archive/v1.13.2/ninja-1.13.2.tar.gz'
download_file 'https://github.com/mesonbuild/meson/releases/download/1.10.2/meson-1.10.2.tar.gz'
download_file 'https://ftp.gnu.org/gnu/texinfo/texinfo-7.3.tar.xz'
download_file 'https://www.kernel.org/pub/linux/utils/util-linux/v2.41/util-linux-2.41.3.tar.xz'
download_file 'https://www.kernel.org/pub/linux/docs/man-pages/man-pages-6.17.tar.xz'
download_file 'https://github.com/Mic92/iana-etc/releases/download/20260310/iana-etc-20260310.tar.gz'
download_file 'https://data.iana.org/time-zones/releases/tzdata2026a.tar.gz'
download_file 'https://zlib.net/fossils/zlib-1.3.2.tar.gz'
download_file 'https://www.sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz'
download_patch 'https://www.linuxfromscratch.org/patches/lfs/13.0/bzip2-1.0.8-install_docs-1.patch'
download_file 'https://github.com/lz4/lz4/releases/download/v1.10.0/lz4-1.10.0.tar.gz'
download_file 'https://github.com/facebook/zstd/releases/download/v1.5.7/zstd-1.5.7.tar.gz'
download_file 'https://ftp.gnu.org/gnu/readline/readline-8.3.tar.gz'
download_file 'https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.47/pcre2-10.47.tar.gz'
download_file 'https://ftp.gnu.org/gnu/bc/bc-1.08.2.tar.gz'
download_file 'https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz'
download_file 'https://distfiles.ariadne.space/pkgconf/pkgconf-2.5.1.tar.xz'
download_file 'https://download.savannah.gnu.org/releases/attr/attr-2.5.2.tar.gz'
download_file 'https://download.savannah.gnu.org/releases/acl/acl-2.3.2.tar.xz'
download_file 'https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.77.tar.xz'
download_file 'https://github.com/besser82/libxcrypt/releases/download/v4.5.2/libxcrypt-4.5.2.tar.xz'
download_file 'https://github.com/shadow-maint/shadow/releases/download/4.19.4/shadow-4.19.4.tar.xz'
download_file 'https://sourceforge.net/projects/psmisc/files/psmisc/psmisc-23.7.tar.xz'
download_file 'https://ftp.gnu.org/gnu/libtool/libtool-2.5.4.tar.xz'
download_file 'https://ftp.gnu.org/gnu/gdbm/gdbm-1.26.tar.gz'
download_file 'https://ftp.gnu.org/gnu/gperf/gperf-3.3.tar.gz'
download_file 'https://github.com/libexpat/libexpat/releases/download/R_2_7_5/expat-2.7.5.tar.xz'
download_file 'https://www.greenwoodsoftware.com/less/less-692.tar.gz'
download_file 'https://ftp.gnu.org/gnu/autoconf/autoconf-2.73.tar.xz'
download_file 'https://ftp.gnu.org/gnu/automake/automake-1.18.tar.xz'
download_file 'https://github.com/openssl/openssl/releases/download/openssl-3.6.1/openssl-3.6.1.tar.gz'
download_file 'https://sourceware.org/ftp/elfutils/0.194/elfutils-0.194.tar.bz2'
download_file 'https://github.com/libffi/libffi/releases/download/v3.5.2/libffi-3.5.2.tar.gz'
download_file 'https://sqlite.org/2026/sqlite-autoconf-3510200.tar.gz'
download_file 'https://ftp.gnu.org/gnu/groff/groff-1.24.1.tar.gz'
download_file 'https://download.savannah.gnu.org/releases/libpipeline/libpipeline-1.5.8.tar.gz'
download_file 'https://github.com/vim/vim/archive/refs/tags/v9.2.0280.tar.gz' 'vim-9.2.0280.tar.gz'
download_file 'https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-34.2.tar.xz'
download_file 'https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-6.19.0.tar.xz'
download_file 'https://www.kernel.org/pub/linux/utils/kbd/kbd-2.9.0.tar.xz'
download_patch 'https://www.linuxfromscratch.org/patches/lfs/13.0/kbd-2.9.0-backspace-1.patch'
download_file 'https://github.com/systemd/systemd/archive/v260.1/systemd-260.1.tar.gz'
download_file 'https://github.com/thom311/libnl/releases/download/libnl3_12_0/libnl-3.12.0.tar.gz'
download_file 'https://github.com/htop-dev/htop/releases/download/3.4.1/htop-3.4.1.tar.xz'
download_file 'https://gitlab.com/OldManProgrammer/unix-tree/-/archive/2.3.2/unix-tree-2.3.2.tar.gz'

exit 0
