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

echo "=== Building Gawk-5.3.0 ==="
if grep "gawk" $LFS/built.txt; then
    echo "Gawk is already built"
else
    tar -xf gawk-5.3.0.tar.xz -C /lfs/tmp/
    mv /lfs/tmp/gawk-5.3.0 /lfs/tmp/gawk
    cd /lfs/tmp/gawk

    # First, ensure some unneeded files are not installed
    sed -i 's/extras//' Makefile.in

    ./configure --prefix=/usr   \
                --host=$LFS_TGT \
                --build=$(build-aux/config.guess)
    make
    make DESTDIR=$LFS install

    cd $LFS/sources
    echo "=== Cleaning up Gawk ==="
    rm -rf /lfs/tmp/gawk
    echo "gawk" >> $LFS/built.txt
fi

cd $LFS/sources
