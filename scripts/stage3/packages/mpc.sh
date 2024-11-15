#!/bin/bash
set -e +h

cd /sources

echo "=== Building MPC-1.3.1 ==="
tar -xf mpc-1.3.1.tar.gz -C /tmp/
mv -v /tmp/mpc-1.3.1 /tmp/mpc
cd /tmp/mpc

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpc-1.3.1
make
make html
make check
make install
make install-html

RETVAL=$?
cd /sources
echo "=== Cleaning up MPC-1.3.1 ==="
rm -rf /tmp/mpc

exit $RETVAL
