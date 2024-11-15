#!/bin/bash
set -e +h

cd /sources

echo "=== Building Automake-1.17 ==="
tar -xf automake-1.17.tar.xz -C /tmp/
mv -v /tmp/automake-1.17 /tmp/automake
cd /tmp/automake

./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.17
make
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up Automake-1.17 ==="
rm -rf /tmp/automake

exit $RETVAL
