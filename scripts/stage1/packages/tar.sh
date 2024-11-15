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

echo "=== Building Tar-1.35 ==="
if grep "tar" $LFS/built.txt; then
    echo "Tar is already built"
else
    tar -xf tar-1.35.tar.xz -C /lfs/tmp/
    mv /lfs/tmp/tar-1.35 /lfs/tmp/tar
    cd /lfs/tmp/tar

    ./configure --prefix=/usr   \
                --host=$LFS_TGT \
                --build=$(build-aux/config.guess)

    make
    make DESTDIR=$LFS install

    cd $LFS/sources
    echo "=== Cleaning up Tar ==="
    rm -rf /lfs/tmp/tar
    echo "tar" >> $LFS/built.txt
fi

cd $LFS/sources
