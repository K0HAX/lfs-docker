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

echo "=== Building Libstdc++ ==="
if grep libstdcpp $LFS/built.txt; then
    echo "Libstdc++ is already built"
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
	../libstdc++-v3/configure           \
		--host=$LFS_TGT                 \
		--build=$(../config.guess)      \
		--prefix=/usr                   \
		--disable-multilib              \
		--disable-nls                   \
		--disable-libstdcxx-pch         \
		--with-gxx-include-dir=/tools/$LFS_TGT/include/c++/14.2.0
    make
    make DESTDIR=$LFS install
    rm -v $LFS/usr/lib/lib{stdc++{,exp,fs},supc++}.la

    cd $LFS/sources
    echo "=== Cleaning up libstdc++ ==="
    rm -rf /lfs/tmp/gcc
    echo "libstdcpp" >> $LFS/built.txt
fi

cd $LFS/sources
