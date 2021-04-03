#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $CURRENT_DIR/scripts/helpers.sh

main() {
    # OPTIONS

    # address vim mode switching delay (http://superuser.com/a/252717/65504)
    if server_option_value_not_changed "escape-time" "500"; then
        tmux set-option -s escape-time 0
    fi

    # increase scrollback buffer size
    if option_value_not_changed "history-limit" "2000"; then
        tmux set-option -g history-limit 50000
    fi

    # tmux messages are displayed for 4 seconds
    if option_value_not_changed "display-time" "750"; then
        tmux set-option -g display-time 4000
    fi

    # refresh 'status-left' and 'status-right' more often
    if option_value_not_changed "status-interval" "15"; then
        tmux set-option -g status-interval 5
    fi

    # required (only) on OS X
    if is_osx && command_exists "reattach-to-user-namespace" && option_value_not_changed "default-command" ""; then
        tmux set-option -g default-command "reattach-to-user-namespace -l $SHELL"
    fi

    # upgrade $TERM, tmux 1.9
    if option_value_not_changed "default-terminal" "screen"; then
        tmux set-option -g default-terminal "screen-256color"
    fi
    # upgrade $TERM, tmux 2.0+
    if server_option_value_not_changed "default-terminal" "screen"; then
        tmux set-option -s default-terminal "screen-256color"
    fi

    # emacs key bindings in tmux command prompt (prefix + :) are better than
    # vi keys, even for vim users
    tmux set-option -g status-keys emacs

    # focus events enabled for terminals that support them
    tmux set-option -g focus-events on

    # super useful when using "grouped sessions" and multi-monitor setup
    if ! iterm_terminal; then
        tmux set-window-option -g aggressive-resize on
    fi

    # DEFAULT KEY BINDINGS

    local prefix="$(prefix)"
    local prefix_without_ctrl="$(prefix_without_ctrl)"

    # if C-b is not prefix
    if [ $prefix != "C-b" ]; then
        # unbind obsolete default binding
        if key_binding_not_changed "C-b" "send-prefix"; then
            tmux unbind-key C-b
        fi

        # pressing `prefix + prefix` sends <prefix> to the shell
        if key_binding_not_set "$prefix"; then
            tmux bind-key "$prefix" send-prefix
        fi
    fi

    # If Ctrl-a is prefix then `Ctrl-a + a` switches between alternate windows.
    # Works for any prefix character.
    if key_binding_not_set "$prefix_without_ctrl"; then
        tmux bind-key "$prefix_without_ctrl" last-window
    fi

    # easier switching between next/prev window
    if key_binding_not_set "C-p"; then
        tmux bind-key C-p previous-window
    fi
    if key_binding_not_set "C-n"; then
        tmux bind-key C-n next-window
    fi

    # source `.tmux.conf` file - as suggested in `man tmux`
    if key_binding_not_set "R"; then
        tmux bind-key R run-shell ' \
            tmux source-file ~/.config/tmux/tmux.conf; \
            tmux display-message "Sourced tmux.conf!"'
    fi
}

main
#vim: set ft=sh ts=4 sw=4 tw=0 et :
