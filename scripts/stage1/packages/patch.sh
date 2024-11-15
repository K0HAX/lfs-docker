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

echo "=== Building Patch-2.7.6 ==="
if grep "patch" $LFS/built.txt; then
    echo "Patch is already built"
else
    tar -xf patch-2.7.6.tar.xz -C /lfs/tmp/
    mv /lfs/tmp/patch-2.7.6 /lfs/tmp/patch
    cd /lfs/tmp/patch

    ./configure --prefix=/usr   \
                --host=$LFS_TGT \
                --build=$(build-aux/config.guess)

    make
    make DESTDIR=$LFS install

    cd $LFS/sources
    echo "=== Cleaning up Patch ==="
    rm -rf /lfs/tmp/patch
    echo "patch" >> $LFS/built.txt
fi

cd $LFS/sources
