#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# bitwarden cli yarn and typescript
[[ `command -v npm` ]] && npm install -g @bitwarden/cli yarn typescript

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

TMUX_TPM_PATH="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TMUX_TPM_PATH" ]; then
    mkdir -p "$TMUX_TPM_PATH"
    git clone https://github.com/tmux-plugin/tpm "$TMUX_TPM_PATH"
fi

# gcp
if [[ ! -d $HOME/google-cloud-sdk ]]; then
    cd $HOME && curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-326.0.0-linux-x86_64.tar.gz
    tar xvf google-cloud-sdk-326.0.0-linux-x86_64.tar.gz $HOME/google-cloud-sdk && rm google-cloud-sdk-326.0.0-linux-x86_64.tar.gz
    $HOME/google-cloud-sdk/install.sh --quiet --path-update false --command-completion false --usage-reporting false
    $HOME/google-cloud-sdk/bin/gcloud init
fi;