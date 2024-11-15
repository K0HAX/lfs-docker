#!/bin/bash
set -e +h

cd /sources

echo "=== Building Ninja-1.12.1 ==="
tar -xf ninja-1.12.1.tar.gz -C /tmp/
mv -v /tmp/ninja-1.12.1 /tmp/ninja
cd /tmp/ninja

export NINJAJOBS=4
sed -i '/int Guess/a \
  int   j = 0;\
  char* jobs = getenv( "NINJAJOBS" );\
  if ( jobs != NULL ) j = atoi( jobs );\
  if ( j > 0 ) return j;\
' src/ninja.cc

# Build Ninja
python3 configure.py --bootstrap

# Install
install -vm755 ninja /usr/bin/
install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja
install -vDm644 misc/zsh-completion  /usr/share/zsh/site-functions/_ninja

RETVAL=$?
cd /sources
echo "=== Cleaning up Ninja-1.12.1 ==="
rm -rf /tmp/ninja

exit $RETVAL
