#!/bin/bash
set -e +h

cd /sources

echo "=== Building Python-3.12.5 ==="
tar -xf Python-3.12.5.tar.xz -C /tmp/
mv -v /tmp/Python-3.12.5 /tmp/python
cd /tmp/python
./configure --prefix=/usr   \
            --enable-shared \
            --without-ensurepip && \
	make && \
	make install
RETCODE=$?

cd /sources
echo "=== Cleaning up Python-3.12.5 ==="
rm -rf /tmp/python
exit $RETCODE
