#!/bin/bash
set -e +h

cd /sources

echo "=== Building Attr-2.5.2 ==="
tar -xf attr-2.5.2.tar.gz -C /tmp/
mv -v /tmp/attr-2.5.2 /tmp/attr
cd /tmp/attr

./configure --prefix=/usr     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/attr-2.5.2
make
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up Attr-2.5.2 ==="
rm -rf /tmp/attr

exit $RETVAL
