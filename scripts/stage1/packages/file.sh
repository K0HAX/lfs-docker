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

echo "=== Building File-5.45 ==="
if grep "file" $LFS/built.txt; then
    echo "File is already built"
else
    tar -xf file-5.45.tar.gz -C /lfs/tmp/
    mv -v /lfs/tmp/file-5.45 /lfs/tmp/file
    cd /lfs/tmp/file

    mkdir build
    pushd build
        ../configure --disable-bzlib      \
                     --disable-libseccomp \
                     --disable-xzlib      \
                     --disable-zlib
        make
    popd
    ./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess)
    make FILE_COMPILE=$(pwd)/build/src/file
    make DESTDIR=$LFS install
    rm -v $LFS/usr/lib/libmagic.la

    cd $LFS/sources
    echo "=== Cleaning up File ==="
    rm -rf /lfs/tmp/file
    echo "file" >> $LFS/built.txt
fi

cd $LFS/sources
