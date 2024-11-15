#!/bin/bash
set -e +h

cd /sources

echo "=== Building Jinja2-3.1.4 ==="
tar -xf jinja2-3.1.4.tar.gz -C /tmp/
mv -v /tmp/jinja2-3.1.4 /tmp/jinja2
cd /tmp/jinja2

# Build
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --no-user --find-links dist Jinja2

RETVAL=$?
cd /sources
echo "=== Cleaning up Jinja2-3.1.4 ==="
rm -rf /tmp/jinja2

exit $RETVAL
