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
# if ([[ -d /opt/cisco ]] && ! pgrep vpnagentd); then
#     /opt/cisco/anyconnect/bin/vpnui &
# fi
if (builtin command -v xsecurelock && ! pgrep xss-lock); then
  . $HOME/.local/bin/auto-lock &
fi

# background daemon
# run playerctld daemon
# run ibus-daemon -drx
run redshift -v
run nitrogen --restore
run unclutter -idle 1
run picom -f --experimental-backends --glx-no-stencil

# tray apps
# run kitty tmux
# run nm-applet
# run jetbrains-toolbox
run pasystray
run blueman-applet
run spotify
run slack
run discord
run optimus-manager-qt
# vim: set ft=sh ts=2 sw=2 tw=0 et :
