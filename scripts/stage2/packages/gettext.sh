#!/bin/bash
set -e +h

cd /sources

echo "=== Building Gettext-0.22.5 ==="
tar -xf gettext-0.22.5.tar.xz -C /tmp/
mv -v /tmp/gettext-0.22.5 /tmp/gettext
cd /tmp/gettext
./configure --disable-shared && \
    make
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin

cd /sources
echo "=== Cleaning up Gettext ==="
rm -rf /tmp/gettext

