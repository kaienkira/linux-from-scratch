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
    local rename_file=$2

    echo "start download $url"

    if [ ! -z "$rename_file" ]
    then
        curl -L -o "$rename_file" "$url"
    else
        curl -L -O "$url"
        if [ $? -ne 0 ]; then exit 1; fi
    fi
}

download_file 'https://ftp.gnu.org/gnu/binutils/binutils-2.45.tar.xz'
download_file 'https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz'
download_file 'https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.2.tar.xz'
download_file 'https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz'
download_file 'https://ftp.gnu.org/gnu/gcc/gcc-15.1.0/gcc-15.1.0.tar.xz'
download_file 'https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.15.9.tar.xz'
download_file 'https://ftp.gnu.org/gnu/glibc/glibc-2.41.tar.xz'
download_file 'https://ftp.gnu.org/gnu/m4/m4-1.4.20.tar.xz'
download_file 'https://ftp.gnu.org/gnu/ncurses/ncurses-6.5.tar.gz'
download_file 'https://ftp.gnu.org/gnu/bash/bash-5.3.tar.gz'

exit 0
