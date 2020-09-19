#!/bin/bash

declare options=(
"alacritty
awesome
dunst
picom
termite
tmux
vim
xresources
zsh
aliases
exports
dmenu
rofi
dotconf
quit"
)
choice=$(echo -e "${options[@]}" | rofi -dmenu -i -p 'Edit config file:' --show-icons)

case "$choice" in
	quit)
		echo "Program terminated." && exit 1
	;;
	alacritty)
		choice="$HOME/.config/alacritty/alacritty.yml"
	;;
	awesome)
		choice="$HOME/.config/awesome/rc.lua"
	;;
	dunst)
		choice="$HOME/.config/dunst/dunstrc"
	;;
	picom)
		choice="$HOME/.config/picom/picom.conf"
	;;
	tmux)
		choice="$HOME/.tmux.conf"
	;;
	termite)
		choice="$HOME/.config/termite/config"
	;;
	vim)
		choice="$HOME/.vimrc"
	;;
	xresources)
		choice="$HOME/.xprofile"
	;;
	rofi)
		choice="$HOME/.config/rofi/config.rasi"
	;;
	zsh)
		choice="$HOME/.zshrc"
	;;
	dotconf)
		choice="$HOME/dotfiles/init/packages.sh"
	;;
	aliases)
		choice="$HOME/.aliases"
	;;
	exports)
		choice="$HOME/.exports"
	;;
	*)
		exit 1
	;;
esac

alacritty -e nvim "$choice" &
