#!/bin/bash
. init/helpers.sh
. init/packages.sh 
. init/install.sh

# install essentials
_update system

if [[ ! -f $HOME/.vim/autoload/plug.vim ]]; then
    echo_info "Installing vim-plug..."
    eval $(curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
                https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim);
fi

# zinit
if [[ ! -d $HOME/.zinit ]]; then
    echo_info "Installing zinit..."
    eval $(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh);
fi;

# tpm
if [[ ! -d $HOME/.tmux/plugins/tpm ]]; then
    echo_info "Install tpm..."
    eval $(git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm);
fi;
# install starship if wanted
# curl -fsSL https://starship.rs/install.sh | bash

# pyenv
if [[ ! -d $HOME/.pyenv ]]; then
    echo_info "Install pyenv..."
    eval $(curl https://pyenv.run | bash);
fi;

# echo_info "Install poetry..."
# eval $(curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python);

# gcp
if [[ ! -d $HOME/google-cloud-sdk ]]; then
    echo_info "Install gcloud..."
    eval $(curl https://sdk.cloud.google.com | bash && exec -l $SHELL);
fi;
# remember to run gcloud init

# nnn plugins install
echo_info "Install nnn plugins..."
eval $(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh);
eval $(git clone https://github.com/sebastiencs/icons-in-terminal.git && cd icons-in-terminal && ./install.sh)
