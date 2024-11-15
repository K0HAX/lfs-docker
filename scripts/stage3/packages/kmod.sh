#!/bin/bash
set -e +h

cd /sources

echo "=== Building Kmod-33 ==="
tar -xf kmod-33.tar.xz -C /tmp/
mv -v /tmp/kmod-33 /tmp/kmod
cd /tmp/kmod

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --with-openssl    \
            --with-xz         \
            --with-zstd       \
            --with-zlib       \
            --disable-manpages
make
make install

for target in depmod insmod modinfo modprobe rmmod; do
  ln -sfv ../bin/kmod /usr/sbin/$target
  rm -fv /usr/bin/$target
done

RETVAL=$?
cd /sources
echo "=== Cleaning up Kmod-33 ==="
rm -rf /tmp/kmod

exit $RETVAL
