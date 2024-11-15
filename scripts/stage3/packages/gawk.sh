#!/bin/bash
set -e +h

cd /sources

echo "=== Building Gawk-5.3.0 ==="
tar -xf gawk-5.3.0.tar.xz -C /tmp/
mv -v /tmp/gawk-5.3.0 /tmp/gawk
cd /tmp/gawk

# ensure some unneeded files are not installed
sed -i 's/extras//' Makefile.in

./configure --prefix=/usr
make
rm -f /usr/bin/gawk-5.3.0
make install

# The installation process already created awk as a symlink to gawk, create its man page as a symlink as well
ln -sv gawk.1 /usr/share/man/man1/awk.1

RETVAL=$?
cd /sources
echo "=== Cleaning up Gawk-5.3.0 ==="
rm -rf /tmp/gawk

exit $RETVAL
