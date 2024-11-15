#!/bin/bash
set -e +h

cd /sources

echo "=== Building Iana-Etc-20240806 ==="
tar -xf iana-etc-20240806.tar.gz -C /tmp/
mv -v /tmp/iana-etc-20240806 /tmp/iana-etc
cd /tmp/iana-etc

cp services protocols /etc

cd /sources
echo "=== Cleaning up Iana-Etc-20240806 ==="
rm -rf /tmp/iana-etc
