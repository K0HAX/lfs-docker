#!/bin/bash
set -e +h

cd /sources

echo "=== Building Expat-2.6.2 ==="
tar -xf expat-2.6.2.tar.xz -C /tmp/
mv -v /tmp/expat-2.6.2 /tmp/expat
cd /tmp/expat

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.6.2
make
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up Expat-2.6.2 ==="
rm -rf /tmp/expat

exit $RETVAL
