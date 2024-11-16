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

echo "=== Building Grep-3.11 ==="
if grep "grep" $LFS/built.txt; then
    echo "Grep is already built"
else
    tar -xf grep-3.11.tar.xz -C /lfs/tmp/
    mv /lfs/tmp/grep-3.11 /lfs/tmp/grep
    cd /lfs/tmp/grep

	./configure --prefix=/usr   \
				--host=$LFS_TGT \
				--build=$(./build-aux/config.guess)
    make
    make DESTDIR=$LFS install

    cd $LFS/sources
    echo "=== Cleaning up Grep ==="
    rm -rf /lfs/tmp/grep
    echo "grep" >> $LFS/built.txt
fi

cd $LFS/sources
