#!/bin/bash
set -e +h

cd /sources

echo "=== Building Acl-2.3.2 ==="
tar -xf acl-2.3.2.tar.xz -C /tmp/
mv -v /tmp/acl-2.3.2 /tmp/acl
cd /tmp/acl

./configure --prefix=/usr         \
            --disable-static      \
            --docdir=/usr/share/doc/acl-2.3.2
make
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up Acl-2.3.2 ==="
rm -rf /tmp/acl

exit $RETVAL
