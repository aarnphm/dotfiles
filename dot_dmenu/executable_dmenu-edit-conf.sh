#!/bin/bash

declare -a options=("alacritty
kitty
.dotfiles
lightdm
lightdm-greeter
awesome
dunst
picom
termite
tmux
vim
zsh
aliases
exports
dmenu-scripts
rofi
mimeapps
quit"
)

choice=$(echo -e "${options[@]}" | rofi -dmenu -i -p 'Edit config file:' --show-icons)

case "$choice" in
	quit)
		echo "Program terminated." && exit 1
	;;
	lightdm)
		choice="/etc/lightdm/lightdm.conf"
	;;
	lightdm-greeter)
		choice="/etc/lightdm/lightdm-mini-greeter.conf"
	;;
    .dotfiles)
		choice="$CHEZMOI_DIR/init.sh"
	;;
	alacritty)
		choice="$CHEZMOI_DIR/private_dot_config/alacritty/alacritty.yml"
	;;
	kitty)
		choice="$CHEZMOI_DIR/private_dot_config/kitty/kitty.conf"
	;;
	mimeapps)
		choice="$CHEZMOI_DIR/private_dot_config/mimeapps.list"
	;;
	awesome)
		choice="$CHEZMOI_DIR/private_dot_config/awesome/rc.lua"
	;;
	dunst)
		choice="$CHEZMOI_DIR/private_dot_config/dunst/dunstrc"
	;;
	picom)
		choice="$CHEZMOI_DIR/private_dot_config/picom/picom.conf"
	;;
	tmux)
		choice="$CHEZMOI_DIR/dot_tmux.conf"
	;;
	termite)
		choice="$CHEZMOI_DIR/private_dot_config/termite/config"
	;;
	vim)
		choice="$CHEZMOI_DIR/dot_vimrc"
	;;
	dmenu-scripts)
		choice="$CHEZMOI_DIR/private_dot_dmenu/dmenu-edit-conf.sh"
	;;
	rofi)
		choice="$CHEZMOI_DIR/private_dot_config/rofi/config.rasi"
	;;
	zsh)
		choice="$CHEZMOI_DIR/dot_zshrc.tmpl"
	;;
	aliases)
		choice="$CHEZMOI_DIR/dot_aliases"
	;;
	exports)
		choice="$CHEZMOI_DIR/dot_zshenv.tmpl"
	;;
	*)
		exit 1
	;;
esac

alacritty -e nvim "$choice"
