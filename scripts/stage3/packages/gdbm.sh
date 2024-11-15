#!/bin/bash
set -e +h

cd /sources

echo "=== Building GDBM-1.24 ==="
tar -xf gdbm-1.24.tar.gz -C /tmp/
mv -v /tmp/gdbm-1.24 /tmp/gdbm
cd /tmp/gdbm

./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat
make
make check
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up GDBM-1.24 ==="
rm -rf /tmp/gdbm

exit $RETVAL
