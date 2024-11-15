#!/bin/bash
set +h
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

echo "=== Building XZ-5.6.2 ==="
if grep "xz" $LFS/built.txt; then
    echo "XZ is already built"
else
    tar -xf xz-5.6.2.tar.xz -C /lfs/tmp/
    mv /lfs/tmp/xz-5.6.2 /lfs/tmp/xz
    cd /lfs/tmp/xz

    ./configure --prefix=/usr                     \
                --host=$LFS_TGT                   \
                --build=$(build-aux/config.guess) \
                --disable-static                  \
                --docdir=/usr/share/doc/xz-5.6.2

    make
    make DESTDIR=$LFS install
    rm -v $LFS/usr/lib/liblzma.la

    cd $LFS/sources
    echo "=== Cleaning up XZ ==="
    rm -rf /lfs/tmp/xz
    echo "xz" >> $LFS/built.txt
fi

cd $LFS/sources
