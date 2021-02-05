#!/bin/bash

declare options=(
"alacritty
kitty
lightdm
lightdm-greeter
awesome
dunst
picom
termite
tmux
vim
xprofile
zsh
aliases
exports
dmenu-scripts
xmonad
rofi
packages
mimeapps
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
	lightdm)
		choice="/etc/lightdm/lightdm.conf"
	;;
	lightdm-greeter)
		choice="/etc/lightdm/lightdm-mini-greeter.conf"
	;;
	kitty)
		choice="$HOME/.config/kitty/kitty.conf"
	;;
	xmonad)
		choice="$HOME/.xmonad/xmonad.hs"
	;;
	mimeapps)
		choice="$HOME/.config/mimeapps.list"
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
	dmenu-scripts)
		choice="$HOME/.dmenu/dmenu-edit-conf.sh"
	;;
	xprofile)
		choice="$HOME/.xprofile"
	;;
	rofi)
		choice="$HOME/.config/rofi/config.rasi"
	;;
	zsh)
		choice="$HOME/.zshrc"
	;;
	packages)
		choice="$HOME/.local/share/chezmoi/run_once_10-install-arch-linux-packages.sh.tmpl"
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

termite --exec="nvim $choice"
