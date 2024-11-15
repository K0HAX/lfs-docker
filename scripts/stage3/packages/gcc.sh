#!/bin/bash
set -e +h

cd /sources

echo "=== Building GCC-14.2.0 ==="
tar -xf gcc-14.2.0.tar.xz -C /tmp/
mv -v /tmp/gcc-14.2.0 /tmp/gcc
cd /tmp/gcc

# If building on x86_64, change the default directory name for 64-bit libraries to “lib”
case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac

# The GCC documentation recommends building GCC in a dedicated build directory
mkdir -v build
cd       build

../configure --prefix=/usr            \
             LD=ld                    \
             --enable-languages=c,c++ \
             --enable-default-pie     \
             --enable-default-ssp     \
             --enable-host-pie        \
             --disable-multilib       \
             --disable-bootstrap      \
             --disable-fixincludes    \
             --with-system-zlib
make
ulimit -s -H unlimited
# Now remove/fix several known test failures
sed -e '/cpython/d'               -i ../gcc/testsuite/gcc.dg/plugin/plugin.exp
sed -e 's/no-pic /&-no-pie /'     -i ../gcc/testsuite/gcc.target/i386/pr113689-1.c
sed -e 's/300000/(1|300000)/'     -i ../libgomp/testsuite/libgomp.c-c++-common/pr109062.c
sed -e 's/{ target nonpic } //' \
    -e '/GOTPCREL/d'              -i ../gcc/testsuite/gcc.target/i386/fentryname3.c

# Test the results as a non-privileged user, but do not stop at errors
#chown -R tester .
#su tester -c "PATH=$PATH make -k check"
#../contrib/test_summary
make install

# Fix ownership
chown -v -R root:root \
    /usr/lib/gcc/$(gcc -dumpmachine)/14.2.0/include{,-fixed}

# Create a symlink required by the FHS for "historical" reasons
ln -svr /usr/bin/cpp /usr/lib

# Many packages use the name cc to call the C compiler. We've already created cc as a symlink in gcc-pass2, create its man page as a symlink as well
ln -sv gcc.1 /usr/share/man/man1/cc.1

# Add a compatibility symlink to enable building programs with Link Time Optimization (LTO)
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/14.2.0/liblto_plugin.so \
        /usr/lib/bfd-plugins/

# Now that our final toolchain is in place, it is important to again ensure that compiling and linking will work as expected. We do this by performing some sanity checks
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'

# Now make sure that we're set up to use the correct start files
grep -E -o '/usr/lib.*/S?crt[1in].*succeeded' dummy.log

# Verify that the compiler is searching for the correct header files
grep -B4 '^ /usr/include' dummy.log

# Verify that the new linker is being used with the correct search paths
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'

# Make sure that we're using the correct libc
grep "/lib.*/libc.so.6 " dummy.log

# Make sure GCC is using the correct dynamic linker
grep 'found ld-linux' dummy.log

# Clean up test files
rm -v dummy.c a.out dummy.log

# Move a misplaced file
mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib

RETVAL=$?
cd /sources
echo "=== Cleaning up GCC-14.2.0 ==="
rm -rf /tmp/gcc

exit $RETVAL
