#!/bin/bash
set -e +h

cd /sources

echo "=== Building Findutils-4.10.0 ==="
tar -xf findutils-4.10.0.tar.xz -C /tmp/
mv -v /tmp/findutils-4.10.0 /tmp/findutils
cd /tmp/findutils

./configure --prefix=/usr --localstatedir=/var/lib/locate
make
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up Findutils-4.10.0 ==="
rm -rf /tmp/findutils

exit $RETVAL
