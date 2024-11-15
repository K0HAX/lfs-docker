#!/bin/bash
set -e +h

cd /sources

echo "=== Building File-5.45 ==="
tar -xf file-5.45.tar.gz -C /tmp/
mv -v /tmp/file-5.45 /tmp/file
cd /tmp/file

./configure --prefix=/usr
make
make check
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up File-5.45 ==="
rm -rf /tmp/file

exit $RETVAL
