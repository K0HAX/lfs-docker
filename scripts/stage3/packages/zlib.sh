#!/bin/bash
set -e +h

cd /sources

echo "=== Building Zlib-1.3.1 ==="
tar -xf zlib-1.3.1.tar.gz -C /tmp/
mv -v /tmp/zlib-1.3.1 /tmp/zlib
cd /tmp/zlib

./configure --prefix=/usr && \
    make && \
    make check && \
    make install && \
    rm -fv /usr/lib/libz.a

RETVAL=$?
cd /sources
echo "=== Cleaning up Zlib-1.3.1 ==="
rm -rf /tmp/zlib

exit $RETVAL
