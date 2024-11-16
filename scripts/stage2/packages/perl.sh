#!/bin/bash
set -e +h

cd /sources

echo "=== Building Perl-5.40.0 ==="
tar -xf perl-5.40.0.tar.xz -C /tmp/
mv -v /tmp/perl-5.40.0 /tmp/perl
cd /tmp/perl
sh Configure -des                                         \
             -D prefix=/usr                               \
             -D vendorprefix=/usr                         \
             -D useshrplib                                \
             -D privlib=/usr/lib/perl5/5.40/core_perl     \
             -D archlib=/usr/lib/perl5/5.40/core_perl     \
             -D sitelib=/usr/lib/perl5/5.40/site_perl     \
             -D sitearch=/usr/lib/perl5/5.40/site_perl    \
             -D vendorlib=/usr/lib/perl5/5.40/vendor_perl \
             -D vendorarch=/usr/lib/perl5/5.40/vendor_perl && \
    make && make install

cd /sources
echo "=== Cleaning up Perl-5.40.0 ==="
rm -rf /tmp/perl
