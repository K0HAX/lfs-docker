#!/bin/bash
set -e +h

cd /sources

echo "=== Building Lz4-1.10.0 ==="
tar -xf lz4-1.10.0.tar.gz -C /tmp/
mv -v /tmp/lz4-1.10.0 /tmp/lz4
cd /tmp/lz4

make BUILD_STATIC=no PREFIX=/usr
make -j1 check
make BUILD_STATIC=no PREFIX=/usr install

RETVAL=$?
cd /sources
echo "=== Cleaning up Lz4-1.10.0 ==="
rm -rf /tmp/lz4

exit $RETVAL
