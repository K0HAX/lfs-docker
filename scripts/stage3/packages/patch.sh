#!/bin/bash
set -e +h

cd /sources

echo "=== Building Patch-2.7.6 ==="
tar -xf patch-2.7.6.tar.xz -C /tmp/
mv -v /tmp/patch-2.7.6 /tmp/patch
cd /tmp/patch

./configure --prefix=/usr
make
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up Patch-2.7.6 ==="
rm -rf /tmp/patch

exit $RETVAL
