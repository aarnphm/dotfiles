#!/bin/bash

set -e

. packages.sh

##############################################
# Distro options
##############################################

export PKGMN=pacman
export PKGOPT=(--needed --noconfirm)
export PKGU=-Syu
export PKGI=-Sy
export PKGR=-Rns

##############################################
# Functions
##############################################

function echo_error() {
  printf '\n\033[31mERROR:\033[0m %s\n' "$1"
}

function echo_warning() {
  printf '\n\033[33mWARNING:\033[0m %s\n' "$1"
}

function echo_done() {
  printf '\n\033[32mDONE:\033[0m %s\n' "$1"
}

function echo_info() {
  printf '\n\033[36m%s\033[0m\n' "$1"
}


function _update() {
  if [[ $1 == "system" ]]; then
    echo_info "Updating system packages..."
    sudo "$PKGMN" "$PKGU" "${PKGOPT[@]}"
  else
    echo_info "Ugrading ${1}..."
    sudo "$PKGMN" "$PKGU" "$1"
  fi
}

function _install() {
  if [[ $1 == "core" ]]; then
    for pkg in "${PKG[@]}"; do
      echo_info "Installing ${pkg}..."
      if ! [ -x "$(command -v rainbow)" ]; then
        sudo "$PKGMN" "$PKGI" "${PKGOPT[@]}" "$pkg" 
      else
        rainbow --red=error --yellow=warning sudo "$PKGMN" "$PKGI" "${PKGOPT[@]}" "$pkg" 
      fi
      echo_done "${pkg} installed!"
    done
   elif [[ $1 == "aur" ]]; then
    for aur in "${AUR[@]}"; do
     echo_info "Installing ${aur} ..."
     yay -Sy "$aur" --needed --noconfirm
     echo_done "${aur} installed!"
    done
   else
    echo_info "Installing ${1} ..."
    sudo "$PKGMN" "$PKGI" "$1"
  fi
}

##############################################
# Install and setup first time
##############################################

echo_info "Installing from core ..."
_install core

echo_info "Installing from AUR ..."
_install aur

# log cron
crontab `chezmoi source-path`/linux_conf/cronfile

# bitwarden 
npm install -g @bitwarden/cli

if [[ ! -f $HOME/.vim/autoload/plug.vim ]]; then
    echo_info "Installing vim-plug..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim;
fi

# zinit
if [[ ! -d $HOME/.zinit ]]; then
    echo_info "Installing zinit..."
    curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh;
fi;

# tpm
if [[ ! -d $HOME/.tmux/plugins/tpm ]]; then
    echo_info "Install tpm..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm;
fi;

# pyenv
if [[ ! -d $HOME/.pyenv ]]; then
    echo_info "Install pyenv..."
    curl https://pyenv.run | bash;
    exit;
fi;

# nnn plugins install
echo_info "Install nnn plugins..."
curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh;
git clone https://github.com/sebastiencs/icons-in-terminal.git && cd icons-in-terminal && ./install.sh


# gcp
if [[ ! -d $HOME/google-cloud-sdk ]]; then
    echo_info "Install gcloud..."
    curl https://sdk.cloud.google.com | bash && exec -l $SHELL;
fi;
