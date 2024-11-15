#!/bin/bash
set -e +h

cd /sources

echo "=== Building Libpipeline-1.5.7 ==="
tar -xf libpipeline-1.5.7.tar.gz -C /tmp/
mv -v /tmp/libpipeline-1.5.7 /tmp/libpipeline
cd /tmp/libpipeline

./configure --prefix=/usr
make
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up Libpipeline-1.5.7 ==="
rm -rf /tmp/libpipeline

exit $RETVAL
