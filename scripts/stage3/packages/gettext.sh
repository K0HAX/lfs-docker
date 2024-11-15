#!/bin/bash
set -e +h

cd /sources

echo "=== Building Gettext-0.22.5 ==="
tar -xf gettext-0.22.5.tar.xz -C /tmp/
mv -v /tmp/gettext-0.22.5 /tmp/gettext
cd /tmp/gettext

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-0.22.5
make
make install
chmod -v 0755 /usr/lib/preloadable_libintl.so

RETVAL=$?
cd /sources
echo "=== Cleaning up Gettext-0.22.5 ==="
rm -rf /tmp/gettext

exit $RETVAL
