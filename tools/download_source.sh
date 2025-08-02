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

exit 0
