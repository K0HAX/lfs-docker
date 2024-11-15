#!/bin/bash
set -e +h

cd /sources

echo "=== Building Bc-6.7.6 ==="
tar -xf bc-6.7.6.tar.xz -C /tmp/
mv -v /tmp/bc-6.7.6 /tmp/bc
cd /tmp/bc

CC=gcc ./configure --prefix=/usr -G -O3 -r
make
make test
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up Bc-6.7.6 ==="
rm -rf /tmp/bc

exit $RETVAL
