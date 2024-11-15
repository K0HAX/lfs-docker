#!/bin/bash
set -e +h

cd /sources

echo "=== Building Shadow-4.16.0 ==="
tar -xf shadow-4.16.0.tar.xz -C /tmp/
mv -v /tmp/shadow-4.16.0 /tmp/shadow
cd /tmp/shadow

# Disable the installation of the groups program and its man pages, as Coreutils provides a better version. Also, prevent the installation of manual pages that were already installed
sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;

# Instead of using the default crypt method, use the much more secure YESCRYPT method of password encryption, which also allows passwords longer than 8 characters. It is also necessary to change the obsolete /var/spool/mail location for user mailboxes that Shadow uses by default to the /var/mail location used currently. And, remove /bin and /sbin from the PATH, since they are simply symlinks to their counterparts in /usr.
sed -e 's:#ENCRYPT_METHOD DES:ENCRYPT_METHOD YESCRYPT:' \
    -e 's:/var/spool/mail:/var/mail:'                   \
    -e '/PATH=/{s@/sbin:@@;s@/bin:@@}'                  \
    -i etc/login.defs
touch /usr/bin/passwd
./configure --sysconfdir=/etc   \
            --disable-static    \
            --with-{b,yes}crypt \
            --without-libbsd    \
            --with-group-name-max-length=32
make
make exec_prefix=/usr install
make -C man install-man
# Enable shadowed user passwords
pwconv
# Enable shadowed group passwords
grpconv

# Set the beginning group id to 999
mkdir -p /etc/default
useradd -D --gid 999

# Do not create mail directories for new users by default
sed -i '/MAIL/s/yes/no/' /etc/default/useradd

RETVAL=$?
cd /sources
echo "=== Cleaning up Shadow-4.16.0 ==="
rm -rf /tmp/shadow

exit $RETVAL
