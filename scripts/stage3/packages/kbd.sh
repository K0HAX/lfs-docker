#!/bin/bash
set -e +h

cd /sources

echo "=== Building Kbd-2.6.4 ==="
tar -xf kbd-2.6.4.tar.xz -C /tmp/
mv -v /tmp/kbd-2.6.4 /tmp/kbd
cd /tmp/kbd

patch -Np1 -i /sources/kbd-2.6.4-backspace-1.patch
sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
./configure --prefix=/usr --disable-vlock
make
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up Kbd-2.6.4 ==="
rm -rf /tmp/kbd

exit $RETVAL
