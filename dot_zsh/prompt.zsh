#!/usr/bin/env zsh

setopt correct auto_menu
setopt autocd autopushd multios
setopt complete_in_word
setopt pushd_ignore_dups
setopt pushd_silent pushd_to_home cdable_vars
setopt extendedglob
setopt hist_ignore_all_dups inc_append_history

unsetopt clobber
setopt prompt_subst
# autoload -Uz vcs_info
autoload -Uz colors && colors

# Prompt symbol
COMMON_PROMPT_SYMBOL=">"

# Colors
COMMON_COLORS_HOST_ME=green
COMMON_COLORS_HOST_AWS_VAULT=yellow
COMMON_COLORS_CURRENT_DIR=blue
COMMON_COLORS_RETURN_STATUS_TRUE=yellow
COMMON_COLORS_RETURN_STATUS_FALSE=red
COMMON_COLORS_GIT_STATUS_DEFAULT=green
COMMON_COLORS_GIT_STATUS_STAGED=red
COMMON_COLORS_GIT_STATUS_UNSTAGED=yellow
COMMON_COLORS_GIT_PROMPT_SHA=green

# Left Prompt
PROMPT='$(common_host)$(common_current_dir)$(common_git_status)$(common_return_status)'

# Host
# me="%n@%m"
common_host() {
    me="%m"
    if [[ -n $me ]]; then
        echo "%{$fg[$COMMON_COLORS_HOST_ME]%}$me%{$reset_color%}:"
    fi
}

# Current directory
common_current_dir() {
    echo -n "%{$fg[$COMMON_COLORS_CURRENT_DIR]%}%c "
}

# Prompt symbol
common_return_status() {
    echo -n "%(?.%F{$COMMON_COLORS_RETURN_STATUS_TRUE}.%F{$COMMON_COLORS_RETURN_STATUS_FALSE})$COMMON_PROMPT_SYMBOL%f "
}

# Git status
common_git_status() {
    local message=""
    local message_color="%F{$COMMON_COLORS_GIT_STATUS_DEFAULT}"

    # https://git-scm.com/docs/git-status#_short_format
    local staged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU]")
    local unstaged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU? ][MADRCU?]")

    if [[ -n ${staged} ]]; then
        message_color="%F{$COMMON_COLORS_GIT_STATUS_STAGED}"
    elif [[ -n ${unstaged} ]]; then
        message_color="%F{$COMMON_COLORS_GIT_STATUS_UNSTAGED}"
    fi

    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n ${branch} ]]; then
        message+="${message_color}${branch}%f "
    fi

    echo -n "${message}"
}
