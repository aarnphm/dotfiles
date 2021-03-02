#!/usr/bin/env zsh

#==============================================================#
##          Prompt Configuration                              ##
#==============================================================#

###     git      ###
autoload -Uz VCS_INFO_get_data_git; VCS_INFO_get_data_git 2> /dev/null

function rprompt-git-current-branch {
    local name st color gitdir action
    if [[ "$PWD" =~ /\.git(/.*)?$ ]]; then
        return
    fi
    name=$(git symbolic-ref HEAD 2> /dev/null)
    name=${name##refs/heads/}
    if [[ -z $name ]]; then
        return
    fi

    gitdir=$(git rev-parse --git-dir 2> /dev/null)
    action=$(VCS_INFO_git_getaction "$gitdir") && action="($action)"

    st=$(git status 2> /dev/null)
    if echo "$st" | grep -q "^nothing to"; then
        color=%F{green}
    elif echo "$st" | grep -q "^nothing added"; then
        color=%F{yellow}
    elif echo "$st" | grep -q "^# Untracked"; then
        color=%B%F{red}
    else
        color=%F{red}
    fi
    echo "($color$name$action%f%b)"
}

function __show_status() {
    exit_status=${pipestatus[*]}
    local SETCOLOR_DEFAULT="%f"
    local SETCOLOR=${SETCOLOR_DEFAULT}
    local s
    for s in $(echo -en "${exit_status}"); do
        if [ "${s}" -eq 147 ] ; then
            SETCOLOR=${SETCOLOR_DEFAULT}
            break
        elif [ "${s}" -gt 100 ] ; then
            SETCOLOR="%F{red}"
            break
        elif [ "${s}" -gt 0 ] ; then
            SETCOLOR="%F{yellow}"
        fi
    done
    if [ "${SETCOLOR}" != "${SETCOLOR_DEFAULT}" ]; then
        echo -ne "${SETCOLOR}(${exit_status// /|})%f%b"
    else
        echo -ne "${SETCOLOR}%f%b"
    fi
}

PROMPT='[%n@%m:%.$(rprompt-git-current-branch)]${WINDOW:+"[$WINDOW]"}$(__show_status) %B> '
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
export PROMPT4='+%N:%i> '
