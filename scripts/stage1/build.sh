#!/bin/bash
# Set Environment
export LFS=/mnt/lfs
echo $LFS

# Get sources
echo "=== Getting sources ==="
if grep 'sources-prep1' $LFS/built.txt; then
    echo "Sources prepped already"
else
    rm -f $LFS/sources
    mkdir -v $LFS/sources
    chmod -v a+wt $LFS/sources

    ln -s /lfs/sources/* $LFS/sources/

    pushd $LFS/sources
      md5sum -c md5sums
    popd

    chown root:root /lfs/sources/*
    chown root:root $LFS/sources/*
    echo 'sources-prep1' >> $LFS/built.txt
fi

echo "=== Building Limited Directory Layout ==="
if grep 'dir-layout' $LFS/built.txt; then
    echo "Directory layout exists!"
else
    mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}

    for i in bin lib sbin; do
      ln -sv usr/$i $LFS/$i
    done

    case $(uname -m) in
      x86_64) mkdir -pv $LFS/lib64 ;;
    esac

    mkdir -pv $LFS/tools

    echo 'dir-layout' >> $LFS/built.txt
fi

echo "=== Creating LFS User ==="
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs

if grep 'lfs-user' $LFS/built.txt; then
    echo "LFS User already set up!"
else
    chown -v lfs $LFS/{usr{,/*},lib,lib64,var,etc,bin,sbin,tools}
    case $(uname -m) in
      x86_64) chown -v lfs $LFS/lib64 ;;
    esac

    echo 'lfs-user' >> $LFS/built.txt
fi

chmod a+rw $LFS/built.txt

echo "=== Running build-sudo.sh as 'lfs'"
mkdir -v /lfs/tmp
chown lfs:lfs /lfs/tmp
chmod a+rwx /lfs/tmp
chown -R lfs:lfs /mnt/lfs
#sudo -u lfs -g lfs -i /lfs/scripts/build-sudo.sh

# Change ownership
#chown --from lfs -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools}
#case $(uname -m) in
#    x86_64) chown --from lfs -R root:root $LFS/lib64 ;;
#esac
#
#mkdir -pv $LFS/{dev,proc,sys,run}

# Done building core environment!
