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

echo "=== Building glibc-2.40 ==="
if grep 'glibc-240' $LFS/built.txt; then
    echo "Glibc-2.40 already built"
else
    tar -xf glibc-2.40.tar.xz -C /lfs/tmp/
    mv -v /lfs/tmp/glibc-2.40 /lfs/tmp/glibc
    cd /lfs/tmp/glibc

    case $(uname -m) in
        i?86)   ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
        ;;
        x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
            ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
        ;;
    esac

    patch -Np1 -i /mnt/lfs/sources/glibc-2.40-fhs-1.patch

    mkdir -v build
    cd build
    echo "rootsbindir=/usr/sbin" > configparms
    ../configure                             \
          --prefix=/usr                      \
          --host=$LFS_TGT                    \
          --build=$(../scripts/config.guess) \
          --enable-kernel=4.19               \
          --with-headers=$LFS/usr/include    \
          --disable-nscd                     \
          libc_cv_slibdir=/usr/lib
    make && make DESTDIR=$LFS install
    sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd
    echo 'int main(){}' | $LFS_TGT-gcc -xc -
    if [[ $? != 0 ]]; then
        echo "GCC: Test 1 failed! Bailing out!"
        exit 1
    fi
    readelf -l a.out | grep ld-linux
    if [[ $? != 0 ]]; then
        echo "GCC: Test 2 failed! Bailing out!"
        exit 1
    fi

    rm -v a.out

    cd $LFS/sources
    echo "=== Cleaning up glibc-2.40 ==="
    rm -rf /lfs/tmp/glibc

    echo "glibc-240" >> $LFS/built.txt
fi

cd $LFS/sources
