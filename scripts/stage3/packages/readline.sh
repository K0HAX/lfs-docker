#!/bin/bash
set -e +h

cd /sources

echo "=== Building Readline-8.2.13 ==="
tar -xf readline-8.2.13.tar.gz -C /tmp/
mv -v /tmp/readline-8.2.13 /tmp/readline
cd /tmp/readline

sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install
sed -i 's/-Wl,-rpath,[^ ]*//' support/shobj-conf

./configure --prefix=/usr    \
            --disable-static \
            --with-curses    \
            --docdir=/usr/share/doc/readline-8.2.13
make SHLIB_LIBS="-lncursesw"
make SHLIB_LIBS="-lncursesw" install
install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-8.2.13

RETVAL=$?
cd /sources
echo "=== Cleaning up Readline-8.2.13 ==="
rm -rf /tmp/readline

exit $RETVAL
