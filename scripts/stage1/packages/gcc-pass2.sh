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

echo "=== Building GCC-14.2.0 - Pass 2 ==="
if grep "gcc-phase2" $LFS/built.txt; then
    echo "GCC Phase 2 is already built"
else
    tar -xf gcc-14.2.0.tar.xz -C /lfs/tmp/
    mv -v /lfs/tmp/gcc-14.2.0 /lfs/tmp/gcc
    cd /lfs/tmp/gcc

    tar -xf /lfs/sources/mpfr-4.2.1.tar.xz
    tar -xf /lfs/sources/gmp-6.3.0.tar.xz
    tar -xf /lfs/sources/mpc-1.3.1.tar.gz
    mv -v mpfr-4.2.1 mpfr
    mv -v gmp-6.3.0 gmp
    mv -v mpc-1.3.1 mpc

    case $(uname -m) in
      x86_64)
        sed -e '/m64=/s/lib64/lib/' \
            -i.orig gcc/config/i386/t-linux64
     ;;
    esac

    # Override the building rule of libgcc and libstdc++ headers,
    # to allow building these libraries with POSIX threads support
    sed '/thread_header =/s/@.*@/gthr-posix.h/' \
        -i libgcc/Makefile.in libstdc++-v3/include/Makefile.in

    mkdir -v build
    cd build

    ../configure                                       \
        --build=$(../config.guess)                     \
        --host=$LFS_TGT                                \
        --target=$LFS_TGT                              \
        LDFLAGS_FOR_TARGET=-L$PWD/$LFS_TGT/libgcc      \
        --prefix=/usr                                  \
        --with-build-sysroot=$LFS                      \
        --enable-default-pie                           \
        --enable-default-ssp                           \
        --disable-nls                                  \
        --disable-multilib                             \
        --disable-libatomic                            \
        --disable-libgomp                              \
        --disable-libquadmath                          \
        --disable-libsanitizer                         \
        --disable-libssp                               \
        --disable-libvtv                               \
        --enable-languages=c,c++
    make
    make DESTDIR=$LFS install
    ln -sv gcc $LFS/usr/bin/cc

    cd $LFS/sources
    echo "=== Cleaning up GCC - Pass 2 ==="
    rm -rf /lfs/tmp/gcc
    echo "gcc-phase2" >> $LFS/built.txt
fi

cd $LFS/sources
