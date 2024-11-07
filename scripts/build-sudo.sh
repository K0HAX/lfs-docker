#!/bin/bash
# Set Environment
export LFS=/mnt/lfs

# Set up environment
cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > ~/.bashrc << "EOF"
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
EOF

source ~/.bashrc

export MAKEFLAGS="-j$(nproc)"

echo "/usr/bin/awk: $(ls -alh /etc/alternatives/awk)"
echo "awk should be a symlink to gawk"
echo "/usr/bin/yacc: $(ls -lah /etc/alternatives/yacc)"
echo "yacc should be a symlink to bison"

echo "=== Building binutils-2.43.1 ==="
if grep binutils $LFS/built.txt; then
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
    echo "binutils" >> $LFS/built.txt
fi
echo "=== DONE Building binutils-2.43.1 ==="

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
    cd /mnt/lfs/sources
    echo "=== Cleaning up gcc ==="
    rm -rf /lfs/tmp/gcc
    echo "gcc-phase1" >> $LFS/built.txt
fi
echo "=== DONE Building GCC-14.2.0 - Pass 1 ==="
