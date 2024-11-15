#!/bin/bash
set -e +h

cd /sources

echo "=== Building Vim-9.1.0660 ==="
tar -xf vim-9.1.0660.tar.gz -C /tmp/
mv -v /tmp/vim-9.1.0660 /tmp/vim
cd /tmp/vim

# Change the default location of the vimrc configuration file to /etc
echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
./configure --prefix=/usr
make
make install

ln -sv vim /usr/bin/vi
for L in  /usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done

ln -sv ../vim/vim91/doc /usr/share/doc/vim-9.1.0660

# Configure vim
cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

" Ensure defaults are set before customizing settings, not after
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1

set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
EOF

RETVAL=$?
cd /sources
echo "=== Cleaning up Vim-9.1.0660 ==="
rm -rf /tmp/vim

exit $RETVAL
