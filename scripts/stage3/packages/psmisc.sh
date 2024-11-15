#!/bin/bash
set -e +h

cd /sources

echo "=== Building Psmisc-23.7 ==="
tar -xf psmisc-23.7.tar.xz -C /tmp/
mv -v /tmp/psmisc-23.7 /tmp/psmisc
cd /tmp/psmisc

./configure --prefix=/usr
make
make check
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up Psmisc-23.7 ==="
rm -rf /tmp/psmisc

exit $RETVAL
