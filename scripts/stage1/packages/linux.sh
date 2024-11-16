#!/bin/bash
set -e +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE

export MAKEFLAGS="-j$(nproc)"

echo "=== Building Linux-6.6.58 API Headers ==="
if grep 'linux-api-headers' $LFS/built.txt; then
    echo "Linux-6.6.58 API Headers already built."
else
    tar -xf linux-6.6.58.tar.xz -C /lfs/tmp/
    mv -v /lfs/tmp/linux-6.6.58 /lfs/tmp/linux
    cd /lfs/tmp/linux
    make mrproper
    make headers
    find usr/include -type f ! -name '*.h' -delete
    cp -rv usr/include $LFS/usr

    cd /mnt/lfs/sources
    echo "=== Cleaning up Linux-6.6.58 ==="
    rm -rf /lfs/tmp/linux

    echo "linux-api-headers" >> $LFS/built.txt
fi
echo "=== DONE Building Linux-6.6.58 API Headers ===1"

cd /mnt/lfs/sources
