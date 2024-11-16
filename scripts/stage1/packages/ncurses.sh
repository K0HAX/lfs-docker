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

echo "=== Building ncurses-6.5 ==="
if grep "ncurses" $LFS/built.txt; then
    echo "ncurses is already built"
else
    tar -xf ncurses-6.5.tar.gz -C /lfs/tmp/
    mv -v /lfs/tmp/ncurses-6.5 /lfs/tmp/ncurses
    cd /lfs/tmp/ncurses

	sed -i s/mawk// configure
	mkdir build
	pushd build
	  ../configure
	  make -C include
	  make -C progs tic
	popd
	./configure --prefix=/usr                \
				--host=$LFS_TGT              \
				--build=$(./config.guess)    \
				--mandir=/usr/share/man      \
				--with-manpage-format=normal \
				--with-shared                \
				--without-normal             \
				--with-cxx-shared            \
				--without-debug              \
				--without-ada                \
				--disable-stripping
    make
    make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install
    ln -sv libncursesw.so $LFS/usr/lib/libncurses.so
    sed -e 's/^#if.*XOPEN.*$/#if 1/' \
        -i $LFS/usr/include/curses.h

    cd $LFS/sources
    echo "=== Cleaning up ncurses ==="
    rm -rf /lfs/tmp/ncurses
    echo "ncurses" >> $LFS/built.txt
fi

cd $LFS/sources
