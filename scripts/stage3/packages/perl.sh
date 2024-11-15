#!/bin/bash
set -e +h

cd /sources

echo "=== Building Perl-5.40.0 ==="
tar -xf perl-5.40.0.tar.xz -C /tmp/
mv -v /tmp/perl-5.40.0 /tmp/perl
cd /tmp/perl

# This version of Perl builds the Compress::Raw::Zlib and Compress::Raw::BZip2 modules. By default Perl will use an internal copy of the sources for the build. Issue the following command so that Perl will use the libraries installed on the system
export BUILD_ZLIB=False
export BUILD_BZIP2=0

sh Configure -des                                          \
             -D prefix=/usr                                \
             -D vendorprefix=/usr                          \
             -D privlib=/usr/lib/perl5/5.40/core_perl      \
             -D archlib=/usr/lib/perl5/5.40/core_perl      \
             -D sitelib=/usr/lib/perl5/5.40/site_perl      \
             -D sitearch=/usr/lib/perl5/5.40/site_perl     \
             -D vendorlib=/usr/lib/perl5/5.40/vendor_perl  \
             -D vendorarch=/usr/lib/perl5/5.40/vendor_perl \
             -D man1dir=/usr/share/man/man1                \
             -D man3dir=/usr/share/man/man3                \
             -D pager="/usr/bin/less -isR"                 \
             -D useshrplib                                 \
             -D usethreads

make
make install
unset BUILD_ZLIB BUILD_BZIP2

RETVAL=$?
cd /sources
echo "=== Cleaning up Perl-5.40.0 ==="
rm -rf /tmp/perl

exit $RETVAL
