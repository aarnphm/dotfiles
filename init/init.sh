#!/bin/bash
. init/helpers.sh
. init/package.sh 
. init/install.sh

# install essentials
_update system

echo_info "Installing vim-plug..."
eval $(curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim);

# zinit
echo_info "Installing zinit..."
eval $(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh);

# tpm
echo_info "Install tpm..."
eval $(git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm);
# install starship if wanted
# curl -fsSL https://starship.rs/install.sh | bash

# pyenv
echo_info "Install pyenv..."
eval $(curl https://pyenv.run | bash);

# gcp
echo_info "Install gcloud..."
eval $(curl https://sdk.cloud.google.com | bash && exec -l $SHELL);
# remember to run gcloud init

# nnn plugins install
echo_info "Install nnn plugins..."
eval $(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh);
eval $(git clone https://github.com/sebastiencs/icons-in-terminal.git && cd icons-in-terminal && ./install.sh)
