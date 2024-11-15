#!/bin/bash
set -e +h

cd /sources

echo "=== Building XML-Parser-2.47 ==="
tar -xf XML-Parser-2.47.tar.gz -C /tmp/
mv -v /tmp/XML-Parser-2.47 /tmp/XML-Parser
cd /tmp/XML-Parser

perl Makefile.PL
make
make install

RETVAL=$?
cd /sources
echo "=== Cleaning up XML-Parser-2.47 ==="
rm -rf /tmp/XML-Parser

exit $RETVAL
