#!/bin/bash
set -e +h

cd /sources

echo "=== Building Flex-2.6.4 ==="
tar -xf flex-2.6.4.tar.gz -C /tmp/
mv -v /tmp/flex-2.6.4 /tmp/flex
cd /tmp/flex

./configure --prefix=/usr \
            --docdir=/usr/share/doc/flex-2.6.4 \
            --disable-static
make
make check
make install
ln -sv flex   /usr/bin/lex
ln -sv flex.1 /usr/share/man/man1/lex.1

RETVAL=$?
cd /sources
echo "=== Cleaning up Flex-2.6.4 ==="
rm -rf /tmp/flex

exit $RETVAL
