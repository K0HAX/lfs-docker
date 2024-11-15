#!/bin/bash
set -e +h

cd /sources

echo "=== Building IPRoute2-6.10.0 ==="
tar -xf iproute2-6.10.0.tar.xz -C /tmp/
mv -v /tmp/iproute2-6.10.0 /tmp/iproute2
cd /tmp/iproute2

# The arpd program included in this package will not be built since it depends on Berkeley DB, which is not installed in LFS. However, a directory and a man page for arpd will still be installed. Prevent this.
sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8

make NETNS_RUN_DIR=/run/netns
make SBINDIR=/usr/sbin install

RETVAL=$?
cd /sources
echo "=== Cleaning up IPRoute2-6.10.0 ==="
rm -rf /tmp/iproute2

exit $RETVAL
