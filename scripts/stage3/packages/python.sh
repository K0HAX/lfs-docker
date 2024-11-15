#!/bin/bash
set -e +h

cd /sources

echo "=== Building Python-3.12.5 ==="
tar -xf Python-3.12.5.tar.xz -C /tmp/
mv -v /tmp/Python-3.12.5 /tmp/python
cd /tmp/python

./configure --prefix=/usr        \
            --enable-shared      \
            --with-system-expat  \
            --enable-optimizations
make
make install

cat > /etc/pip.conf << EOF
[global]
root-user-action = ignore
disable-pip-version-check = true
EOF

RETVAL=$?
cd /sources
echo "=== Cleaning up Python-3.12.5 ==="
rm -rf /tmp/python

exit $RETVAL
