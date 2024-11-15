#!/bin/bash
set -e +h

cd /sources

echo "=== Building Intltool-0.51.0 ==="
tar -xf intltool-0.51.0.tar.gz -C /tmp/
mv -v /tmp/intltool-0.51.0 /tmp/intltool
cd /tmp/intltool

# First fix a warning that is caused by perl-5.22 and later
sed -i 's:\\\${:\\\$\\{:' intltool-update.in

./configure --prefix=/usr
make
make install
install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO

RETVAL=$?
cd /sources
echo "=== Cleaning up Intltool-0.51.0 ==="
rm -rf /tmp/intltool

exit $RETVAL
