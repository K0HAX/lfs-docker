#!/bin/bash
set -e +h

cd /sources

echo "=== Building Tar-1.35 ==="
tar -xf tar-1.35.tar.xz -C /tmp/
mv -v /tmp/tar-1.35 /tmp/tar
cd /tmp/tar

FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr
make
make install
make -C doc install-html docdir=/usr/share/doc/tar-1.35

RETVAL=$?
cd /sources
echo "=== Cleaning up Tar-1.35 ==="
rm -rf /tmp/tar

exit $RETVAL
