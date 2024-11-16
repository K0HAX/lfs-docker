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

echo "=== Building Findutils-4.10.0 ==="
if grep "findutils" $LFS/built.txt; then
    echo "Findutils is already built"
else
    tar -xf findutils-4.10.0.tar.xz -C /lfs/tmp/
    mv -v /lfs/tmp/findutils-4.10.0 /lfs/tmp/findutils
    cd /lfs/tmp/findutils

    ./configure --prefix=/usr                   \
                --localstatedir=/var/lib/locate \
                --host=$LFS_TGT                 \
                --build=$(build-aux/config.guess)
    make
    make DESTDIR=$LFS install

    cd $LFS/sources
    echo "=== Cleaning up Findutils ==="
    rm -rf /lfs/tmp/findutils
    echo "findutils" >> $LFS/built.txt
fi

cd $LFS/sources
