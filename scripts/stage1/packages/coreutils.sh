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

echo "=== Building Coreutils-9.5 ==="
if grep "coreutils" $LFS/built.txt; then
    echo "Coreutils is already built"
else
    tar -xf coreutils-9.5.tar.xz -C /lfs/tmp/
    mv -v /lfs/tmp/coreutils-9.5 /lfs/tmp/coreutils
    cd /lfs/tmp/coreutils

    ./configure --prefix=/usr                     \
                --host=$LFS_TGT                   \
                --build=$(build-aux/config.guess) \
                --enable-install-program=hostname \
                --enable-no-install-program=kill,uptime

    make
    make DESTDIR=$LFS install

    mv -v $LFS/usr/bin/chroot              $LFS/usr/sbin
    mkdir -pv $LFS/usr/share/man/man8
    mv -v $LFS/usr/share/man/man1/chroot.1 $LFS/usr/share/man/man8/chroot.8
    sed -i 's/"1"/"8"/'                    $LFS/usr/share/man/man8/chroot.8

    cd $LFS/sources
    echo "=== Cleaning up Coreutils ==="
    rm -rf /lfs/tmp/coreutils
    echo "coreutils" >> $LFS/built.txt
fi

cd $LFS/sources
