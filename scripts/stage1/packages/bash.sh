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

echo "=== Building Bash-5.2.32 ==="
if grep '^bash$' $LFS/built.txt; then
    echo "Bash is already built"
else
    tar -xf bash-5.2.32.tar.gz -C /lfs/tmp/
    mv -v /lfs/tmp/bash-5.2.32 /lfs/tmp/bash
    cd /lfs/tmp/bash

    ./configure --prefix=/usr                      \
                --build=$(sh support/config.guess) \
                --host=$LFS_TGT                    \
                --without-bash-malloc              \
                bash_cv_strtold_broken=no
    make
    make DESTDIR=$LFS install
    ln -sv bash $LFS/bin/sh

    cd $LFS/sources
    echo "=== Cleaning up bash ==="
    rm -rf /lfs/tmp/bash
    echo "bash" >> $LFS/built.txt
fi

cd $LFS/sources
