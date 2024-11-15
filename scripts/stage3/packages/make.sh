#!/bin/bash
set -e +h

cd /sources

echo "=== Building Make-4.4.1 ==="
tar -xf make-4.4.1.tar.gz -C /tmp/
mv -v /tmp/make-4.4.1 /tmp/make
cd /tmp/make

./configure --prefix=/usr
make
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up Make-4.4.1 ==="
rm -rf /tmp/make

exit $RETVAL
