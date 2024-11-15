#!/bin/bash
set -e +h

cd /sources

echo "=== Building Flit-Core-3.9.0 ==="
tar -xf flit_core-3.9.0.tar.gz -C /tmp/
mv -v /tmp/flit_core-3.9.0 /tmp/flit_core
cd /tmp/flit_core

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --no-user --find-links dist flit_core

RETVAL=$?
cd /sources
echo "=== Cleaning up Flit-Core-3.9.0 ==="
rm -rf /tmp/flit_core

exit $RETVAL
