#!/bin/bash
set -e +h

cd /sources

echo "=== Building DejaGNU-1.6.3 ==="
tar -xf dejagnu-1.6.3.tar.gz -C /tmp/
mv -v /tmp/dejagnu-1.6.3 /tmp/dejagnu
cd /tmp/dejagnu

mkdir -v build
cd       build
../configure --prefix=/usr
makeinfo --html --no-split -o doc/dejagnu.html ../doc/dejagnu.texi
makeinfo --plaintext       -o doc/dejagnu.txt  ../doc/dejagnu.texi
make check
make install
install -v -dm755  /usr/share/doc/dejagnu-1.6.3
install -v -m644   doc/dejagnu.{html,txt} /usr/share/doc/dejagnu-1.6.3

RETVAL=$?
cd /sources
echo "=== Cleaning up DejaGNU-1.6.3 ==="
rm -rf /tmp/dejagnu

exit $RETVAL
