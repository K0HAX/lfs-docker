#!/bin/bash
set -e +h

cd /sources

echo "=== Building Inetutils-2.5 ==="
tar -xf inetutils-2.5.tar.xz -C /tmp/
mv -v /tmp/inetutils-2.5 /tmp/inetutils
cd /tmp/inetutils

# First, make the package build with gcc-14.1 or later
sed -i 's/def HAVE_TERMCAP_TGETENT/ 1/' telnet/telnet.c

./configure --prefix=/usr        \
            --bindir=/usr/bin    \
            --localstatedir=/var \
            --disable-logger     \
            --disable-whois      \
            --disable-rcp        \
            --disable-rexec      \
            --disable-rlogin     \
            --disable-rsh        \
            --disable-servers
make
make install
mv -v /usr/{,s}bin/ifconfig

RETVAL=$?
cd /sources
echo "=== Cleaning up Inetutils-2.5 ==="
rm -rf /tmp/inetutils

exit $RETVAL
