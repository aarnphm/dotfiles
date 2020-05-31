sudo apt-get update && sudo apt-get install git curl wget
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
curl -fsSL https://starship.rs/install.sh | bash
curl https://pyenv.run | bash

