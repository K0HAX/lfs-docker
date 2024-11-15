#!/bin/bash
set -e +h

cd /sources

echo "=== Building Bison-3.8.2 ==="
tar -xf bison-3.8.2.tar.xz -C /tmp/
mv -v /tmp/bison-3.8.2 /tmp/bison
cd /tmp/bison

./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.8.2
make
make install


RETVAL=$?
cd /sources
echo "=== Cleaning up Bison-3.8.2 ==="
rm -rf /tmp/bison

exit $RETVAL
