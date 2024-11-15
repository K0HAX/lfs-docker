#!/bin/bash
set -e +h

cd /sources

echo "=== Building Libelf from Elfutils-0.191 ==="
tar -xf elfutils-0.191.tar.bz2 -C /tmp/
mv -v /tmp/elfutils-0.191 /tmp/elfutils
cd /tmp/elfutils

./configure --prefix=/usr                \
            --disable-debuginfod         \
            --enable-libdebuginfod=dummy
make
make -C libelf install
install -vm644 config/libelf.pc /usr/lib/pkgconfig
rm /usr/lib/libelf.a

RETVAL=$?
cd /sources
echo "=== Cleaning up Libelf from Elfutils-0.191 ==="
rm -rf /tmp/elfutils

exit $RETVAL
