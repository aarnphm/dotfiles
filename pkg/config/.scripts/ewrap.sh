#!/usr/bin/env bash

if ! { [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; } then
    # Remove option --tab for new window
    alacritty --tab -e "vim \"$*\""
else
    # tmux session running
    tmux split-window -h "vim \"$*\""
fi
