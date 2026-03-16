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
download_file 'https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.18.18.tar.xz'
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
download_file 'https://ftp.gnu.org/gnu/texinfo/texinfo-7.3.tar.xz'
download_file 'https://www.kernel.org/pub/linux/utils/util-linux/v2.41/util-linux-2.41.3.tar.xz'

exit 0
