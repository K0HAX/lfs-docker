#!/bin/bash
set -e +h

cd /sources

echo "=== Building Groff-1.23.0 ==="
tar -xf groff-1.23.0.tar.gz -C /tmp/
mv -v /tmp/groff-1.23.0 /tmp/groff
cd /tmp/groff

PAGE=letter ./configure --prefix=/usr
make
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up Groff-1.23.0 ==="
rm -rf /tmp/groff

exit $RETVAL
