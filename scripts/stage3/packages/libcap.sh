#!/bin/bash
set -e +h

cd /sources

echo "=== Building Libcap-2.70 ==="
tar -xf libcap-2.70.tar.xz -C /tmp/
mv -v /tmp/libcap-2.70 /tmp/libcap
cd /tmp/libcap

# Prevent static libraries from being installed
sed -i '/install -m.*STA/d' libcap/Makefile

make prefix=/usr lib=lib
make test
make prefix=/usr lib=lib install

RETVAL=$?
cd /sources
echo "=== Cleaning up Libcap-2.70 ==="
rm -rf /tmp/libcap

exit $RETVAL
