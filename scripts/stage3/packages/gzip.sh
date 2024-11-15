#!/bin/bash
set -e +h

cd /sources

echo "=== Building Gzip-1.13 ==="
tar -xf gzip-1.13.tar.xz -C /tmp/
mv -v /tmp/gzip-1.13 /tmp/gzip
cd /tmp/gzip

./configure --prefix=/usr
make
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up Gzip-1.13 ==="
rm -rf /tmp/gzip

exit $RETVAL
