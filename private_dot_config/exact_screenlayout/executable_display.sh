#!/usr/bin/env bash

if (xrandr | grep "^DP-0.8" &>/dev/null); then
	dp=/home/aarnphm/.config/screenlayout/dual-side.sh
else
	dp=/home/aarnphm/.config/screenlayout/one.sh
fi

[ -x "$dp" ] && . "$dp"

unset dp
