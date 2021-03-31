#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $CURRENT_DIR/helpers.sh

VSPLIT="|"
HSPLIT="-"
VPER=3
HPER=2

W=$(tmux display -p '#{window_width}')
H=$(tmux display -p '#{window_height}')

VS=$(expr $W \* $VPER / 10)
HS=$(expr $H \* $HPER / 10)

# split panes using | and -
main(){
    tmux bind-key "$VSPLIT" split-window -h -c "#{pane_current_path}"\; resize-pane -x $VS
    tmux bind-key "$HSPLIT" split-window -v -c "#{pane_current_path}"\; resize-pane -y $HS
}

main
#vim: set ft=bash ts=2 sw=2 tw=0 et :
