#!/bin/bash
set -e +h

cd /sources

echo "=== Building M4-1.4.19 ==="
tar -xf m4-1.4.19.tar.xz -C /tmp/
mv -v /tmp/m4-1.4.19 /tmp/m4
cd /tmp/m4

./configure --prefix=/usr
make
#make check
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up M4-1.4.19 ==="
rm -rf /tmp/m4

exit $RETVAL
