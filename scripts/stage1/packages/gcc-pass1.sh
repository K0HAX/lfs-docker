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

echo "=== Building GCC-14.2.0 - Pass 1 ==="
if grep gcc-phase1 $LFS/built.txt; then
    echo "GCC Phase 1 is already built."
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

    mkdir -v build
    cd build
    ../configure                  \
        --target=$LFS_TGT         \
        --prefix=$LFS/tools       \
        --with-glibc-version=2.40 \
        --with-sysroot=$LFS       \
        --with-newlib             \
        --without-headers         \
        --enable-default-pie      \
        --enable-default-ssp      \
        --disable-nls             \
        --disable-shared          \
        --disable-multilib        \
        --disable-threads         \
        --disable-libatomic       \
        --disable-libgomp         \
        --disable-libquadmath     \
        --disable-libssp          \
        --disable-libvtv          \
        --disable-libstdcxx       \
        --enable-languages=c,c++

    make && make install
    echo "Exit Code: $?"
    cd ..
    cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
        `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include/limits.h
    cd /mnt/lfs/sources
    echo "=== Cleaning up gcc ==="
    rm -rf /lfs/tmp/gcc
    echo "gcc-phase1" >> $LFS/built.txt
fi
echo "=== DONE Building GCC-14.2.0 - Pass 1 ==="

cd /mnt/lfs/sources

