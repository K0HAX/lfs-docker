#!/bin/bash
set -e +h

cd /sources

echo "=== Building Libtool-2.4.7 ==="
tar -xf libtool-2.4.7.tar.xz -C /tmp/
mv -v /tmp/libtool-2.4.7 /tmp/libtool
cd /tmp/libtool

./configure --prefix=/usr
make
make install

# Remove a useless static library
rm -fv /usr/lib/libltdl.a

RETVAL=$?
cd /sources
echo "=== Cleaning up Libtool-2.4.7 ==="
rm -rf /tmp/libtool

exit $RETVAL
