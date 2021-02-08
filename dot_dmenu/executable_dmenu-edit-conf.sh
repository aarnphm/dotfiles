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
chez_path=$(chezmoi source-path)

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
		choice="$chez_path/init.sh"
	;;
	alacritty)
		choice="$chez_path/private_dot_config/alacritty/alacritty.yml"
	;;
	kitty)
		choice="$chez_path/private_dot_config/kitty/kitty.conf"
	;;
	mimeapps)
		choice="$chez_path/private_dot_config/mimeapps.list"
	;;
	awesome)
		choice="$chez_path/private_dot_config/awesome/rc.lua"
	;;
	dunst)
		choice="$chez_path/private_dot_config/dunst/dunstrc"
	;;
	picom)
		choice="$chez_path/private_dot_config/picom/picom.conf"
	;;
	tmux)
		choice="$chez_path/dot_tmux.conf"
	;;
	termite)
		choice="$chez_path/private_dot_config/termite/config"
	;;
	vim)
		choice="$chez_path/dot_vimrc"
	;;
	dmenu-scripts)
		choice="$chez_path/private_dot_dmenu/dmenu-edit-conf.sh"
	;;
	rofi)
		choice="$chez_path/private_dot_config/rofi/config.rasi"
	;;
	zsh)
		choice="$chez_path/dot_zshrc.tmpl"
	;;
	aliases)
		choice="$chez_path/dot_aliases"
	;;
	exports)
		choice="$chez_path/dot_zshenv.tmpl"
	;;
	*)
		exit 1
	;;
esac

alacritty -e nvim "$choice" && chezmoi apply -v
