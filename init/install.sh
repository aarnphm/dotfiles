#!/bin/bash

set -e

. init/distro.sh
. init/packages.sh
. init/helpers.sh

if ! command -v yay &> /dev/null; then
    echo_info "Installing yay ..."
    sudo "$PKGMN" -S git base-devel;
    git clone https://aur.archlinux.org/yay.git $HOME/yay;
    cd $HOME/yay && makepkg -si && cd $HOME;
fi;

echo_info "Installing from core ..."
_install core

echo_info "Installing from AUR ..."
_install aur
