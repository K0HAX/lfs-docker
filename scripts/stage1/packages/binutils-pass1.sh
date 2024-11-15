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

echo "=== Building binutils-2.43.1 ==="
if grep "binutils-pass1" $LFS/built.txt; then
    echo "binutils is already built."
else
    cd /mnt/lfs/sources
    mkdir -pv /lfs/tmp/binutils
    tar -xf binutils-2.43.1.tar.xz -C /lfs/tmp/binutils
    cd /lfs/tmp/binutils/binutils-*
    mkdir build
    cd build
    ../configure --prefix=$LFS/tools \
                 --with-sysroot=$LFS \
                 --target=$LFS_TGT   \
                 --disable-nls       \
                 --enable-gprofng=no \
                 --disable-werror    \
                 --enable-new-dtags  \
                 --enable-default-hash-style=gnu
    make && make install
    echo "Exit Code: $?"
    cd /mnt/lfs/sources
    echo "=== Cleaning up binutils ==="
    rm -rf /lfs/tmp/binutils
    echo "binutils-pass1" >> $LFS/built.txt
fi
echo "=== DONE Building binutils-2.43.1 ==="

cd /mnt/lfs/sources
