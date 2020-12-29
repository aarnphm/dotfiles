#!/bin/bash
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

gpu=$(glxinfo | grep "server glx vendor string" | sed 's/.*://')

SESSION=${1:-awesome}

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# specific screen startup
#if [ $gpu == " NVIDIA Corporation" ]; then
#    sf=$HOME/.screenlayout/dual.sh
#else
#    sf=$HOME/.screenlayout/one.sh
#fi
#[ -x "$sf" ] && . "$sf"

[ -f ~/.xprofile ] && . ~/.xprofile

# ibus-daemon -drx &
exec awesome

