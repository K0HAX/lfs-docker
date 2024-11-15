#!/bin/bash
set -e +h

cd /sources

echo "=== Building Sed-4.9 ==="
tar -xf sed-4.9.tar.xz -C /tmp/
mv -v /tmp/sed-4.9 /tmp/sed
cd /tmp/sed

./configure --prefix=/usr
make
make html
make install
install -d -m755           /usr/share/doc/sed-4.9
install -m644 doc/sed.html /usr/share/doc/sed-4.9

RETVAL=$?
cd /sources
echo "=== Cleaning up Sed-4.9 ==="
rm -rf /tmp/sed

exit $RETVAL
