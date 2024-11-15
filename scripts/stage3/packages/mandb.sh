#!/bin/bash
set -e +h

cd /sources

echo "=== Building Man-DB-2.12.1 ==="
tar -xf man-db-2.12.1.tar.xz -C /tmp/
mv -v /tmp/man-db-2.12.1 /tmp/man-db
cd /tmp/man-db

./configure --prefix=/usr                         \
            --docdir=/usr/share/doc/man-db-2.12.1 \
            --sysconfdir=/etc                     \
            --disable-setuid                      \
            --enable-cache-owner=bin              \
            --with-browser=/usr/bin/lynx          \
            --with-vgrind=/usr/bin/vgrind         \
            --with-grap=/usr/bin/grap             \
            --with-systemdtmpfilesdir=            \
            --with-systemdsystemunitdir=
make
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up Man-DB-2.12.1 ==="
rm -rf /tmp/man-db

exit $RETVAL
