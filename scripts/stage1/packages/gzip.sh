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

echo "=== Building Gzip-1.13 ==="
if grep "gzip" $LFS/built.txt; then
    echo "Gzip is already built"
else
    tar -xf gzip-1.13.tar.xz -C /lfs/tmp/
    mv /lfs/tmp/gzip-1.13 /lfs/tmp/gzip
    cd /lfs/tmp/gzip

    ./configure --prefix=/usr --host=$LFS_TGT
    make
    make DESTDIR=$LFS install

    cd $LFS/sources
    echo "=== Cleaning up Gzip ==="
    rm -rf /lfs/tmp/gzip
    echo "gzip" >> $LFS/built.txt
fi

cd $LFS/sources
