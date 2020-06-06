#!/bin/bash
. helpers.sh
. package.sh 

# install essentials
_install core
_update system

# link vscode settings
if [[ "$OSTYPE"=="linux-gnu"* ]]; then
	ln -s vscode/settings.json $HOME/.config/Code/User/
fi

# prezto
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
# zinit
bash <(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)
# tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# install starship if wanted
if  [[ "$OSTYPE" == "darwin" ]]; then
	bash <(curl -fsSL https://starship.rs/install.sh)
fi
# pyenv
bash <(curl https://pyenv.run)
# install both yarn and npm
sudo apt-get add <(curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg)
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install yarn

# install gcp
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
gcloud init
