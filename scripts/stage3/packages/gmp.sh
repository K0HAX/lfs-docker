#!/bin/bash
set -e +h

cd /sources

echo "=== Building GMP-6.3.0 ==="
tar -xf gmp-6.3.0.tar.xz -C /tmp/
mv -v /tmp/gmp-6.3.0 /tmp/gmp
cd /tmp/gmp

./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.3.0
make
make html
make check 2>&1 | tee gmp-check-log
awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log
make install
make install-html

RETVAL=$?
cd /sources
echo "=== Cleaning up GMP-6.3.0 ==="
rm -rf /tmp/gmp

exit $RETVAL
