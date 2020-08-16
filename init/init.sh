#!/bin/bash
. helpers.sh
. package.sh 
. install.sh

# install essentials
_update system

# prezto
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
# zinit
curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh
# tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# install starship if wanted
	curl -fsSL https://starship.rs/install.sh | bash
# pyenv
curl https://pyenv.run | bash
# yarn because npm sucks

# install gcp
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
gcloud init
