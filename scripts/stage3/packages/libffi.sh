#!/bin/bash
set -e +h

cd /sources

echo "=== Building Libffi-3.4.6 ==="
tar -xf libffi-3.4.6.tar.gz -C /tmp/
mv -v /tmp/libffi-3.4.6 /tmp/libffi
cd /tmp/libffi

./configure --prefix=/usr          \
            --disable-static       \
            --with-gcc-arch=native
make
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up Libffi-3.4.6 ==="
rm -rf /tmp/libffi

exit $RETVAL
