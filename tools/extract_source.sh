#!/bin/bash

set -o pipefail

script_name=`basename "$0"`
script_abs_name=`readlink -f "$0"`
script_path=`dirname "$script_abs_name"`

src_dir=`readlink -f "$script_path"/../src`

cd "$src_dir"
if [ $? -ne 0 ]; then exit 1; fi

for file_path in \
    $(find "$src_dir" -mindepth 1 -maxdepth 1 -type f -name '*.tar.*')
do
    package_file_name=`basename "$file_path"`
    package_dir_name=${package_file_name%%.tar.*}

    if [ -d "$src_dir"/"$package_dir_name" ]
    then
        continue
    fi

    # delete old version files
    package_name=${package_file_name%%-*}
    find "$src_dir" -mindepth 1 -maxdepth 1 -type d \
        -name "$package_name*" -exec rm -rf {} \;
    if [ $? -ne 0 ]; then exit 1; fi

    tar -xvf "$file_path" -C "$src_dir"
    if [ $? -ne 0 ]; then exit 1; fi
done

exit 0
