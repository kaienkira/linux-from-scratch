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

    if [ -z "$filename" ]
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
    curl -L -o "$file_name" "$url"
    if [ $? -ne 0 ]; then exit 1; fi

    return 0
}

download_file 'https://ftp.gnu.org/gnu/binutils/binutils-2.45.tar.xz'
download_file 'https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz'
download_file 'https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.2.tar.xz'
download_file 'https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz'
download_file 'https://ftp.gnu.org/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.xz'
download_file 'https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.17.7.tar.xz'
download_file 'https://ftp.gnu.org/gnu/glibc/glibc-2.42.tar.xz'
download_file 'https://ftp.gnu.org/gnu/m4/m4-1.4.20.tar.xz'
download_file 'https://ftp.gnu.org/gnu/ncurses/ncurses-6.5.tar.gz'
download_file 'https://ftp.gnu.org/gnu/bash/bash-5.3.tar.gz'
download_file 'https://ftp.gnu.org/gnu/coreutils/coreutils-9.8.tar.xz'
download_file 'https://ftp.gnu.org/gnu/diffutils/diffutils-3.11.tar.xz'
download_file 'https://astron.com/pub/file/file-5.46.tar.gz'
download_file 'https://ftp.gnu.org/gnu/findutils/findutils-4.10.0.tar.xz'
download_file 'https://ftp.gnu.org/gnu/gawk/gawk-5.3.2.tar.xz'
download_file 'https://ftp.gnu.org/gnu/grep/grep-3.12.tar.xz'
download_file 'https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz'
download_file 'https://ftp.gnu.org/gnu/patch/patch-2.8.tar.xz'
download_file 'https://ftp.gnu.org/gnu/sed/sed-4.9.tar.xz'
download_file 'https://ftp.gnu.org/gnu/tar/tar-1.35.tar.xz'
download_file 'https://github.com/tukaani-project/xz/releases/download/v5.8.1/xz-5.8.1.tar.xz'

exit 0
