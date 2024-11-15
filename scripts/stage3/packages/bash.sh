#!/bin/bash
set -e +h

cd /sources

echo "=== Building Bash-5.2.32 ==="
tar -xf bash-5.2.32.tar.gz -C /tmp/
mv -v /tmp/bash-5.2.32 /tmp/bash
cd /tmp/bash

./configure --prefix=/usr             \
            --without-bash-malloc     \
            --with-installed-readline \
            bash_cv_strtold_broken=no \
            --docdir=/usr/share/doc/bash-5.2.32
make
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up Bash-5.2.32 ==="
rm -rf /tmp/bash

exit $RETVAL
