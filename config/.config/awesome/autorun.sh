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
if (command -v  xfce4-power-manager && ! pgrep xfce4-power-man) ; then
    xfce4-power-manager &
fi

run xfsettingsd
run nm-applet
run ibus-daemon 
run nitrogen --restore 
run redshift 
run unclutter -idle 1 
run blueman-tray
# run xcape -e 'Super_L=Super_L|Control_L|Escape'
# run pa-applet
# run xfce4-power-manager


# run blueman-applet
run kdocker -q -o -i /usr/share/icons/ePapirus/16x16/apps/spotify.svg spotify 
run picom -f
run discord 
run optimus-manager-qt
