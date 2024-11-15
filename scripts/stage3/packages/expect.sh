#!/bin/bash
set -e +h

cd /sources

echo "=== Building Expect-5.45.4 ==="
tar -xf expect5.45.4.tar.gz -C /tmp/
mv -v /tmp/expect5.45.4 /tmp/expect
cd /tmp/expect

python3 -c 'from pty import spawn; spawn(["echo", "ok"])'
patch -Np1 -i /sources/expect-5.45.4-gcc14-1.patch
./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --disable-rpath         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include
make
make test
make install
ln -svf expect5.45.4/libexpect5.45.4.so /usr/lib

RETVAL=$?
cd /sources
echo "=== Cleaning up Expect-5.45.4 ==="
rm -rf /tmp/expect

exit $RETVAL
