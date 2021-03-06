#!/usr/bin/env bash

xrandr >| $HOME/.xrandr
if (grep "^DP-0.8 connected" $HOME/.xrandr); then
	dp=/home/aarnphm/.config/screenlayout/dual.sh
else if (grep "^HDMI-0 connected" $HOME/.xrandr); then
    dp=/home/aarnphm/.config/screenlayout/triple.sh
else
	dp=/home/aarnphm/.config/screenlayout/one.sh
fi
[ -x "$dp" ] && . "$dp"

unset dp
