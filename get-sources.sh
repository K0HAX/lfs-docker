#!/bin/bash
if ls src >/dev/null 2>&1; then
    echo "Directory exists! Bailing out!"
    exit 1
fi

mkdir src

pushd src
    wget https://www.linuxfromscratch.org/lfs/view/stable/wget-list-sysv
    wget https://www.linuxfromscratch.org/lfs/view/stable/md5sums
    wget --input-file=./wget-list-sysv --continue --directory-prefix=$(pwd)
popd

