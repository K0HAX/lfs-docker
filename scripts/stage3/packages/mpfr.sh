#!/bin/bash
set -e +h

cd /sources

echo "=== Building MPFR-4.2.1 ==="
tar -xf mpfr-4.2.1.tar.xz -C /tmp/
mv -v /tmp/mpfr-4.2.1 /tmp/mpfr
cd /tmp/mpfr

./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-4.2.1
make
make html
make check
make install
make install-html

RETVAL=$?
cd /sources
echo "=== Cleaning up MPFR-4.2.1 ==="
rm -rf /tmp/mpfr

exit $RETVAL
