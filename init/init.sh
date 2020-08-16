#!/bin/bash
. init/helpers.sh
. init/package.sh 
. init/install.sh

# install essentials
_update system

# zinit
curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh

# tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# install starship if wanted
curl -fsSL https://starship.rs/install.sh | bash

# pyenv
curl https://pyenv.run | bash

# alacritty
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup override set stable
rustup update stable
git clone https://github.com/alacritty/alacritty $HOME/Downloads/alacritty
cd $HOME/Downloads/alacritty && cargo build --release
sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
cd $HOME

# install gcp
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
gcloud init
