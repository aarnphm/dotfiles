#!/usr/bin/env sh

## run (only once) processes which spawn with the same name
function run {
    if (builtin command -v $1 && ! pgrep $1); then
        $@ &
    fi
}

## run (only once) processes which spawn with different name
if (builtin command -v start-pulseaudio-x11 && ! pgrep pulseaudio); then
    start-pulseaudio-x11 &
fi
if (builtin command -v gnome-keyring-daemon && ! pgrep gnome-keyring-d); then
    gnome-keyring-daemon --daemonize --login &
fi
if (builtin command -v /usr/bin/lxpolkit && ! pgrep lxpolkit); then
    /usr/bin/lxpolkit &
fi

if (builtin command -v xdg_menu); then
    xdg_menu --format awesome --root-menu /etc/xdg/menus/arch-applications.menu > $CHEZMOI_DIR/private_dot_config/exact_awesome/xdgmenu.lua
fi

# background daemon
run redshift -v
run playerctld daemon
run ibus-daemon -drx
run nitrogen --restore
run unclutter -idle 1
run picom -f --experimental-backends --glx-no-stencil --show-all-xerrors

# tray apps
run nm-applet
run blueman-applet
run pasystray
run discord
run spotify-tray --client-path=/usr/bin/spotify --minimized --class=spotify
run optimus-manager-qt
