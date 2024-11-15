#!/bin/bash
set -e +h

cd /sources

echo "=== Building Wheel-0.44.0 ==="
tar -xf wheel-0.44.0.tar.gz -C /tmp/
mv -v /tmp/wheel-0.44.0 /tmp/wheel
cd /tmp/wheel

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links=dist wheel

RETVAL=$?
cd /sources
echo "=== Cleaning up Wheel-0.44.0 ==="
rm -rf /tmp/wheel

exit $RETVAL
