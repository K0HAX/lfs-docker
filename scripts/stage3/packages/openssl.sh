#!/bin/bash
set -e +h

cd /sources

echo "=== Building OpenSSL-3.3.1 ==="
tar -xf openssl-3.3.1.tar.gz -C /tmp/
mv -v /tmp/openssl-3.3.1 /tmp/openssl
cd /tmp/openssl

./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic
make
sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install
# Add the version to the documentation directory name, to be consistent with other packages
mv -v /usr/share/doc/openssl /usr/share/doc/openssl-3.3.1

RETVAL=$?
cd /sources
echo "=== Cleaning up OpenSSL-3.3.1 ==="
rm -rf /tmp/openssl

exit $RETVAL
