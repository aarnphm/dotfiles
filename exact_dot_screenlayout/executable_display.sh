#!/bin/bash

xr=$HOME/xrandr.txt
xrandr > $xr

if (grep "^DP-0.8 connected" $xr >/dev/null); then
	dp=/home/aarnphm/.screenlayout/dual-side.sh
else
	dp=/home/aarnphm/.screenlayout/one.sh
fi

[ -x "$dp" ] && . "$dp"
