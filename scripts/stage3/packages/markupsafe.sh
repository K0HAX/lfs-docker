#!/bin/bash
set -e +h

cd /sources

echo "=== Building MarkupSafe-2.1.5 ==="
tar -xf MarkupSafe-2.1.5.tar.gz -C /tmp/
mv -v /tmp/MarkupSafe-2.1.5 /tmp/markupsafe
cd /tmp/markupsafe

# Compile
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --no-user --find-links dist Markupsafe

RETVAL=$?
cd /sources
echo "=== Cleaning up MarkupSafe-2.1.5 ==="
rm -rf /tmp/markupsafe

exit $RETVAL
