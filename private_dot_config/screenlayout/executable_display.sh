#!/usr/bin/env bash

screen_setup="$HOME/.config/screenlayout"

num_screen="$(xrandr -d :0 -q | grep -c ' connected')"

# shellcheck disable=SC2004
if (( $num_screen > 1 )); then
    edp="$(xrandr -d :0 -q | grep ' connected ' | sed -n 1p | grep 'eDP1' &>/dev/null)"
    if $edp; then 
        num_screen=$(("$num_screen" - 1))
    fi
fi

if [[ $num_screen == 3 ]]; then
    dp=$screen_setup/triple.sh
elif [[ $num_screen == 2 ]]; then
	dp=$screen_setup/dual.sh
else
	dp=$screen_setup/one.sh
fi

# shellcheck disable=SC1090
[[ -x "$dp" ]] && . "$dp"

unset dp
