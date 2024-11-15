#!/bin/bash
set -e +h

cd /sources

echo "=== Building Coreutils-9.5 ==="
tar -xf coreutils-9.5.tar.xz -C /tmp/
mv -v /tmp/coreutils-9.5 /tmp/coreutils
cd /tmp/coreutils

patch -Np1 -i /sources/coreutils-9.5-i18n-2.patch

autoreconf -fiv
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime

make
make install
# Move programs to the locations specified by the FHS
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' /usr/share/man/man8/chroot.8

RETVAL=$?
cd /sources
echo "=== Cleaning up Coreutils-9.5 ==="
rm -rf /tmp/coreutils

exit $RETVAL
