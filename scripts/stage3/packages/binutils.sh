#!/bin/bash
set -e +h

cd /sources

echo "=== Building Binutils-2.43.1 ==="
tar -xf binutils-2.43.1.tar.xz -C /tmp/
mv -v /tmp/binutils-2.43.1 /tmp/binutils
cd /tmp/binutils

mkdir -v build
cd       build
../configure --prefix=/usr       \
             --sysconfdir=/etc   \
             --enable-gold       \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --enable-64-bit-bfd \
             --enable-new-dtags  \
             --with-system-zlib  \
             --enable-default-hash-style=gnu
make tooldir=/usr
set +e
make -k check
grep '^FAIL:' $(find -name '*.log')
rm -fv /usr/lib/lib{bfd,ctf,ctf-nobfd,gprofng,opcodes,sframe}.a

RETVAL=$?
cd /sources
echo "=== Cleaning up Binutils-2.43.1 ==="
rm -rf /tmp/binutils

exit $RETVAL
