#!/usr/bin/env bash

## run (only once) processes which spawn with the same name
function run {
   if (command -v $1 && ! pgrep $1); then
     $@&
   fi
}

## run (only once) processes which spawn with different name
if (command -v gnome-keyring-daemon && ! pgrep gnome-keyring-d); then
    gnome-keyring-daemon --daemonize --login &
fi
if (command -v start-pulseaudio-x11 && ! pgrep pulseaudio); then
    start-pulseaudio-x11 &
fi
if (command -v /usr/lib/mate-polkit/polkit-mate-authentication-agent-1 && ! pgrep polkit-mate-aut) ; then
    /usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &
fi

[[ ! -f ${XDG_CONFIG_HOME:-$HOME/.config}/awesome/xdgmenu.lua ]] && xdg_menu --format awesome --root-menu /etc/xdg/menus/arch-applications.menu >${XDG_CONFIG_HOME}/awesome/xdgmenu.lua

run nm-applet
run xscreensaver -no-splash
run playerctld daemon
run pasystray
run ibus-daemon -drx 
run nitrogen --restore 
run picom -f --experimental-backends
run skype
run redshift
run unclutter -idle 1 
run blueman-tray
run discord
run caffeine
run spotify-tray -m -c spotify
run optimus-manager-qt
