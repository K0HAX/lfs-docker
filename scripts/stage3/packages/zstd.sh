#!/bin/bash
set -e +h

cd /sources

echo "=== Building Zstd-1.5.6 ==="
tar -xf zstd-1.5.6.tar.gz -C /tmp/
mv -v /tmp/zstd-1.5.6 /tmp/zstd
cd /tmp/zstd

make prefix=/usr
make check
make prefix=/usr install
rm -v /usr/lib/libzstd.a

RETVAL=$?
cd /sources
echo "=== Cleaning up Zstd-1.5.6 ==="
rm -rf /tmp/zstd

exit $RETVAL
