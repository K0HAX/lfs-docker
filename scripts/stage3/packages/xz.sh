#!/bin/bash
set -e +h

cd /sources

echo "=== Building Xz-5.6.2 ==="
tar -xf xz-5.6.2.tar.xz -C /tmp/
mv -v /tmp/xz-5.6.2 /tmp/xz
cd /tmp/xz

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-5.6.2
make
make check
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up Xz-5.6.2 ==="
rm -rf /tmp/xz

exit $RETVAL
