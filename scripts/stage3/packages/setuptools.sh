#!/bin/bash
set -e +h

cd /sources

echo "=== Building Setuptools-72.2.0 ==="
tar -xf setuptools-72.2.0.tar.gz -C /tmp/
mv -v /tmp/setuptools-72.2.0 /tmp/setuptools
cd /tmp/setuptools

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist setuptools

RETVAL=$?
cd /sources
echo "=== Cleaning up Setuptools-72.2.0 ==="
rm -rf /tmp/setuptools

exit $RETVAL
