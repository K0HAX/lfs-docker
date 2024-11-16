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

echo "=== Building Make-4.4.1 ==="
if grep "make" $LFS/built.txt; then
    echo "Make is already built"
else
    tar -xf make-4.4.1.tar.gz -C /lfs/tmp/
    mv /lfs/tmp/make-4.4.1 /lfs/tmp/make
    cd /lfs/tmp/make

    ./configure --prefix=/usr   \
                --without-guile \
                --host=$LFS_TGT \
                --build=$(build-aux/config.guess)
    make
    make DESTDIR=$LFS install

    cd $LFS/sources
    echo "=== Cleaning up Make ==="
    rm -rf /lfs/tmp/make
    echo "make" >> $LFS/built.txt
fi

cd $LFS/sources
