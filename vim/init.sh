#!/bin/bash

. ../distro.sh
. ../helpers.sh

echo_info "Installing neovim..."
_install neovim
_install python3-neovim

echo_info "Install vim-plug (just to be safe)..."
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
