#!/bin/bash
set -e +h

cd /sources

echo "=== Building Grep-3.11 ==="
tar -xf grep-3.11.tar.xz -C /tmp/
mv -v /tmp/grep-3.11 /tmp/grep
cd /tmp/grep

# First, remove a warning about using egrep and fgrep that makes tests on some packages fail
sed -i "s/echo/#echo/" src/egrep.sh

./configure --prefix=/usr
make
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up Grep-3.11 ==="
rm -rf /tmp/grep

exit $RETVAL
