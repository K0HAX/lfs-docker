#!/bin/bash
# Set Environment
export LFS=/mnt/lfs

# Set up environment
cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > ~/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
EOF

set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE

export MAKEFLAGS="-j$(nproc)"

echo "/usr/bin/awk: $(ls -alh /etc/alternatives/awk)"
echo "awk should be a symlink to gawk"
echo "/usr/bin/yacc: $(ls -lah /etc/alternatives/yacc)"
echo "yacc should be a symlink to bison"

cd /mnt/lfs/sources

#source packages/binutils-pass1.sh
#source packages/gcc-pass1.sh
#source packages/linux.sh
#source packages/glibc-pass1.sh
#source packages/ncurses.sh
#source packages/libstdcpp-stage1.sh
#source packages/m4.sh
#source packages/ncurses.sh
#source packages/bash.sh
#source packages/coreutils.sh
#source packages/diffutils.sh
#source packages/file.sh
#source packages/findutils.sh
#source packages/gawk.sh
#source packages/grep.sh
#source packages/gzip.sh
#source packages/make.sh
#source packages/patch.sh
#source packages/sed.sh
#source packages/tar.sh
#source packages/xz.sh
#source packages/binutils-pass2.sh
#source packages/gcc-pass2.sh

