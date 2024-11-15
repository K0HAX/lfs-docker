#!/bin/bash
set -e +h

cd /sources

echo "=== Building Util-linux-2.40.2 ==="
tar -xf util-linux-2.40.2.tar.xz -C /tmp/
mv -v /tmp/util-linux-2.40.2 /tmp/util-linux
cd /tmp/util-linux

./configure --bindir=/usr/bin     \
            --libdir=/usr/lib     \
            --runstatedir=/run    \
            --sbindir=/usr/sbin   \
            --disable-chfn-chsh   \
            --disable-login       \
            --disable-nologin     \
            --disable-su          \
            --disable-setpriv     \
            --disable-runuser     \
            --disable-pylibmount  \
            --disable-liblastlog2 \
            --disable-static      \
            --without-python      \
            --without-systemd     \
            --without-systemdsystemunitdir        \
            ADJTIME_PATH=/var/lib/hwclock/adjtime \
            --docdir=/usr/share/doc/util-linux-2.40.2

make
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up Util-linux-2.40.2 ==="
rm -rf /tmp/util-linux

exit $RETVAL
