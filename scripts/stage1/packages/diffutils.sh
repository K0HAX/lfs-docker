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

echo "=== Building  Diffutils-3.10 ==="
if grep "diffutils" $LFS/built.txt; then
    echo "Coreutils is already built"
else
    tar -xf diffutils-3.10.tar.xz -C /lfs/tmp/
    mv -v /lfs/tmp/diffutils-3.10 /lfs/tmp/diffutils
    cd /lfs/tmp/diffutils

	./configure --prefix=/usr   \
				--host=$LFS_TGT \
				--build=$(./build-aux/config.guess)
    make
    make DESTDIR=$LFS install

    cd $LFS/sources
    echo "=== Cleaning up Diffutils ==="
    rm -rf /lfs/tmp/diffutils
    echo "diffutils" >> $LFS/built.txt
fi

cd $LFS/sources
