#!/bin/bash
set -e +h

cd /sources

echo "=== Building Check-0.15.2 ==="
tar -xf check-0.15.2.tar.gz -C /tmp/
mv -v /tmp/check-0.15.2 /tmp/check
cd /tmp/check

./configure --prefix=/usr --disable-static
make
make docdir=/usr/share/doc/check-0.15.2 install

RETVAL=$?
cd /sources
echo "=== Cleaning up Check-0.15.2 ==="
rm -rf /tmp/check

exit $RETVAL
