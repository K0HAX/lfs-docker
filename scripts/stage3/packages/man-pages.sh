#!/bin/bash
set -e +h

cd /sources

echo "=== Building Man-pages-6.9.1 ==="
tar -xf man-pages-6.9.1.tar.xz -C /tmp/
mv -v /tmp/man-pages-6.9.1 /tmp/man-pages
cd /tmp/man-pages

rm -v man3/crypt*
make prefix=/usr install

cd /sources
echo "=== Cleaning up Man-pages-6.9.1 ==="
rm -rf /tmp/man-pages
