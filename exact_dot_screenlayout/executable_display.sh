#!/bin/bash

if (xrandr | grep "^DP-0.8" &>/dev/null); then
	dp=/home/aarnphm/.screenlayout/dual-side.sh
else
	dp=/home/aarnphm/.screenlayout/one.sh
fi

[ -x "$dp" ] && . "$dp"

unset dp

