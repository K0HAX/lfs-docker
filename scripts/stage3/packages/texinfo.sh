#!/bin/bash
set -e +h

cd /sources

echo "=== Building Texinfo-7.1 ==="
tar -xf texinfo-7.1.tar.xz -C /tmp/
mv -v /tmp/texinfo-7.1 /tmp/texinfo
cd /tmp/texinfo

./configure --prefix=/usr
make
make install
make TEXMF=/usr/share/texmf install-tex

RETVAL=$?
cd /sources
echo "=== Cleaning up Texinfo-7.1 ==="
rm -rf /tmp/texinfo

exit $RETVAL
