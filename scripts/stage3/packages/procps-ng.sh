#!/bin/bash
set -e +h

cd /sources

echo "=== Building Procps-ng-4.0.4 ==="
tar -xf procps-ng-4.0.4.tar.xz -C /tmp/
mv -v /tmp/procps-ng-4.0.4 /tmp/procps-ng
cd /tmp/procps-ng

./configure --prefix=/usr                           \
            --docdir=/usr/share/doc/procps-ng-4.0.4 \
            --disable-static                        \
            --disable-kill
make
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up Procps-ng-4.0.4 ==="
rm -rf /tmp/procps-ng

exit $RETVAL
