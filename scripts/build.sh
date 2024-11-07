#!/bin/bash
# Set Environment
export LFS=/mnt/lfs
echo $LFS

# Get sources
echo "=== Getting sources ==="
rm -f $LFS/sources
mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources

ln -s /lfs/sources/* $LFS/sources/

pushd $LFS/sources
  md5sum -c md5sums
popd

chown root:root /lfs/sources/*
chown root:root $LFS/sources/*

echo "=== Building Limited Directory Layout ==="
mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}

for i in bin lib sbin; do
  ln -sv usr/$i $LFS/$i
done

case $(uname -m) in
  x86_64) mkdir -pv $LFS/lib64 ;;
esac

mkdir -pv $LFS/tools

echo "=== Creating LFS User ==="
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs

chown -v lfs $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -v lfs $LFS/lib64 ;;
esac

echo "=== Running build-sudo.sh as 'lfs'"
sudo /lfs/scripts/build-sudo.sh

