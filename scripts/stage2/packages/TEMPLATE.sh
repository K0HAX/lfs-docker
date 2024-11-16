#!/bin/bash
set -e +h

cd /sources

echo "=== Building TEMPLATE ==="
tar -xf template.tar.xz -C /tmp/
mv -v /tmp/template /tmp/template
cd /tmp/template

cd /sources
echo "=== Cleaning up TEMPLATE ==="
rm -rf /tmp/template
