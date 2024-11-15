#!/bin/bash
set -e +h

cd /sources

echo "=== Building Ncurses-6.5 ==="
tar -xf ncurses-6.5.tar.gz -C /tmp/
mv -v /tmp/ncurses-6.5 /tmp/ncurses
cd /tmp/ncurses

./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --with-cxx-shared       \
            --enable-pc-files       \
            --with-pkg-config-libdir=/usr/lib/pkgconfig
make

# The installation of this package will overwrite libncursesw.so.6.5 in-place. It may crash the shell process which is using code and data from the library file. Install the package with DESTDIR, and replace the library file correctly using install command (the header curses.h is also edited to ensure the wide-character ABI to be used)
make DESTDIR=$PWD/dest install
install -vm755 dest/usr/lib/libncursesw.so.6.5 /usr/lib
rm -v  dest/usr/lib/libncursesw.so.6.5
sed -e 's/^#if.*XOPEN.*$/#if 1/' \
    -i dest/usr/include/curses.h
cp -av dest/* /

# Many applications still expect the linker to be able to find non-wide-character Ncurses libraries. Trick such applications into linking with wide-character libraries by means of symlinks
for lib in ncurses form panel menu ; do
    ln -sfv lib${lib}w.so /usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc    /usr/lib/pkgconfig/${lib}.pc
done

# Finally, make sure that old applications that look for -lcurses at build time are still buildable
ln -sfv libncursesw.so /usr/lib/libcurses.so

RETVAL=$?
cd /sources
echo "=== Cleaning up Ncurses-6.5 ==="
rm -rf /tmp/ncurses

exit $RETVAL
