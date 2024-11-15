#!/bin/bash
set -e +h

cd /sources

echo "=== Building Pkgconf-2.3.0 ==="
tar -xf pkgconf-2.3.0.tar.xz -C /tmp/
mv -v /tmp/pkgconf-2.3.0 /tmp/pkgconf
cd /tmp/pkgconf

./configure --prefix=/usr              \
            --disable-static           \
            --docdir=/usr/share/doc/pkgconf-2.3.0
make
make install
ln -sv pkgconf   /usr/bin/pkg-config
ln -sv pkgconf.1 /usr/share/man/man1/pkg-config.1

RETVAL=$?
cd /sources
echo "=== Cleaning up Pkgconf-2.3.0 ==="
rm -rf /tmp/pkgconf

exit $RETVAL
