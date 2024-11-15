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

echo "=== Building Binutils-2.43.1 Pass 2 ==="
if grep "binutils-pass2" $LFS/built.txt; then
    echo "Binutils Pass 2 is already built"
else
    tar -xf binutils-2.43.1.tar.xz -C /lfs/tmp/
    mv /lfs/tmp/binutils-2.43.1 /lfs/tmp/binutils
    cd /lfs/tmp/binutils

    sed '6009s/$add_dir//' -i ltmain.sh
    mkdir -v build
    cd build

	../configure                   \
		--prefix=/usr              \
		--build=$(../config.guess) \
		--host=$LFS_TGT            \
		--disable-nls              \
		--enable-shared            \
		--enable-gprofng=no        \
		--disable-werror           \
		--enable-64-bit-bfd        \
		--enable-new-dtags         \
		--enable-default-hash-style=gnu

    make
    make DESTDIR=$LFS install
    rm -v $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}

    cd $LFS/sources
    echo "=== Cleaning up Binutils Pass 2 ==="
    rm -rf /lfs/tmp/binutils
    echo "binutils-pass2" >> $LFS/built.txt
fi

cd $LFS/sources
