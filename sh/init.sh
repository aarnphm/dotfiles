#!/bin/bash
DIR="$(dirname "$0")"
. "$DIR/distro.sh"
. "$DIR/helpers.sh"
. "$DIR/packages.sh" 

# install essentials
_install core
_update system

if [[ -d "~/.zsh" ]]; then
	for d in $HOME/dotfiles/*/; do
		stow $d
	done
fi

if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ];then
	# this is for first time setting up
	
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
	sudo -E bash <(curl -sL https://deb.nodesource.com/setup_14.x)
	sudo apt update && sudo apt install -y nodejs yarn

	# install gcp
	curl https://sdk.cloud.google.com | bash
	exec -l $SHELL
	gcloud init
fi
