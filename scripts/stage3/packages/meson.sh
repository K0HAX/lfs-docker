#!/bin/bash
set -e +h

cd /sources

echo "=== Building Meson-1.5.1 ==="
tar -xf meson-1.5.1.tar.gz -C /tmp/
mv -v /tmp/meson-1.5.1 /tmp/meson
cd /tmp/meson

# Compile
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD

# Install
pip3 install --no-index --find-links dist meson
install -vDm644 data/shell-completions/bash/meson /usr/share/bash-completion/completions/meson
install -vDm644 data/shell-completions/zsh/_meson /usr/share/zsh/site-functions/_meson

RETVAL=$?
cd /sources
echo "=== Cleaning up Meson-1.5.1 ==="
rm -rf /tmp/meson

exit $RETVAL
