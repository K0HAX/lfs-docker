#!/bin/bash
set -e +h

cd /sources

echo "=== Building Less-661 ==="
tar -xf less-661.tar.gz -C /tmp/
mv -v /tmp/less-661 /tmp/less
cd /tmp/less

./configure --prefix=/usr --sysconfdir=/etc
make
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up Less-661 ==="
rm -rf /tmp/less

exit $RETVAL
