#!/bin/bash

. init/distro.sh
. init/packages.sh
. init/helpers.sh

echo_info "Installing from core ..."
_install core

echo_info "Installing from AUR ..."
_install aur
echo_info "Installing vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
