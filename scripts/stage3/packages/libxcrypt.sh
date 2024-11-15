#!/bin/bash
set -e +h

cd /sources

echo "=== Building Libxcrypt-4.4.36 ==="
tar -xf libxcrypt-4.4.36.tar.xz -C /tmp/
mv -v /tmp/libxcrypt-4.4.36 /tmp/libxcrypt
cd /tmp/libxcrypt

./configure --prefix=/usr                \
            --enable-hashes=strong,glibc \
            --enable-obsolete-api=no     \
            --disable-static             \
            --disable-failure-tokens
make
make check
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up Libxcrypt-4.4.36 ==="
rm -rf /tmp/libxcrypt

exit $RETVAL
