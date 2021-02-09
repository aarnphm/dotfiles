#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# bitwarden
[[`command -v npm` ]] && npm install -g @bitwarden/cli yarn

if [[ ! -f $HOME/.vim/autoload/plug.vim ]]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim;
fi

# zinit
if [[ ! -d $HOME/.zinit ]]; then
    mkdir $HOME/.zinit
    git clone https://github.com/zdharma/zinit.git ~/.zinit/bin
fi;

# nnn plugins install
if [[ `command -v nnn` ]]; then
    curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh;
    git clone https://github.com/sebastiencs/icons-in-terminal.git && cd icons-in-terminal && ./install.sh
fi

# gcp
if [[ ! -d $HOME/google-cloud-sdk ]]; then
    curl https://sdk.cloud.google.com | bash ;
fi;

