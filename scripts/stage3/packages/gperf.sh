#!/bin/bash
set -e +h

cd /sources

echo "=== Building Gperf-3.1 ==="
tar -xf gperf-3.1.tar.gz -C /tmp/
mv -v /tmp/gperf-3.1 /tmp/gperf
cd /tmp/gperf

./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.1
make
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up Gperf-3.1 ==="
rm -rf /tmp/gperf

exit $RETVAL
