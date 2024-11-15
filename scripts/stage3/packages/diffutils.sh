#!/bin/bash
set -e +h

cd /sources

echo "=== Building Diffutils-3.10 ==="
tar -xf diffutils-3.10.tar.xz -C /tmp/
mv -v /tmp/diffutils-3.10 /tmp/diffutils
cd /tmp/diffutils

./configure --prefix=/usr
make
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up Diffutils-3.10 ==="
rm -rf /tmp/diffutils

exit $RETVAL
