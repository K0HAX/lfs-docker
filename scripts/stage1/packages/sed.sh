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

echo "=== Building Sed-4.9 ==="
if grep "sed" $LFS/built.txt; then
    echo "Sed is already built"
else
    tar -xf sed-4.9.tar.xz -C /lfs/tmp/
    mv /lfs/tmp/sed-4.9 /lfs/tmp/sed
    cd /lfs/tmp/sed

    ./configure --prefix=/usr   \
                --host=$LFS_TGT \
                --build=$(./build-aux/config.guess)

    make
    make DESTDIR=$LFS install

    cd $LFS/sed
    echo "=== Cleaning up Sed ==="
    rm -rf /lfs/tmp/sed
    echo "sed" >> $LFS/built.txt
fi

cd $LFS/sources
