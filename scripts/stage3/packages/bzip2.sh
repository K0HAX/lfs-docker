#!/bin/bash
set -e +h

cd /sources

echo "=== Building Bzip2-1.0.8 ==="
tar -xf bzip2-1.0.8.tar.gz -C /tmp/
mv -v /tmp/bzip2-1.0.8 /tmp/bzip2
cd /tmp/bzip2

patch -Np1 -i /sources/bzip2-1.0.8-install_docs-1.patch
# The following command ensures installation of symbolic links are relative
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
# Ensure the man pages are installed into the correct location
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

# Prepare Bzip2 for compilation
make -f Makefile-libbz2_so
make clean
make
make PREFIX=/usr install
cp -av libbz2.so.* /usr/lib
ln -sv libbz2.so.1.0.8 /usr/lib/libbz2.so
cp -v bzip2-shared /usr/bin/bzip2
for i in /usr/bin/{bzcat,bunzip2}; do
  ln -sfv bzip2 $i
done
rm -fv /usr/lib/libbz2.a

RETVAL=$?
cd /sources
echo "=== Cleaning up Bzip2-1.0.8 ==="
rm -rf /tmp/bzip2

exit $RETVAL
