#!/bin/bash
set -e +h

cd /sources

echo "=== Building Autoconf-2.72 ==="
tar -xf autoconf-2.72.tar.xz -C /tmp/
mv -v /tmp/autoconf-2.72 /tmp/autoconf
cd /tmp/autoconf

./configure --prefix=/usr
make
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up Autoconf-2.72 ==="
rm -rf /tmp/autoconf

exit $RETVAL
