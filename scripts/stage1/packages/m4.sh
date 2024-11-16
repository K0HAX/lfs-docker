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

echo "=== Building M4 ==="
if grep M4 $LFS/built.txt; then
    echo "M4 is already built"
else
    tar -xf m4-1.4.19.tar.xz -C /lfs/tmp/
    mv -v /lfs/tmp/m4-1.4.19 /lfs/tmp/m4
    cd /lfs/tmp/m4

    ./configure --prefix=/usr   \
                --host=$LFS_TGT \
                --build=$(build-aux/config.guess)

    make
    make DESTDIR=$LFS install

    cd $LFS/sources
    echo "=== Cleaning up M4 ==="
    rm -rf /lfs/tmp/m4
    echo "M4" >> $LFS/built.txt
fi

cd $LFS/sources
