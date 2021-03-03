#==============================================================#
##          Prompt Configuration                              ##
#==============================================================#

# Prompt symbol
PROMPT_SYMBOL="➜"
VICMD_SYMBOL="[vi]"
GIT_UP_ARROW="⇡"
GIT_DOWN_ARROW="⇣"

# Colors
HOST_ME=magenta
CURRENT_DIR=blue
RETURN_STATUS_TRUE=green
RETURN_STATUS_FALSE=red
GIT_STATUS_DEFAULT=green
GIT_STATUS_STAGED=red
GIT_STATUS_UNSTAGED=yellow
GIT_PROMPT_SHA=green

# functions
function __host() {
    me="%n"
    if [[ -n $SSH_CONNECTION ]]; then
        me="%n@%m"
    fi
    if [[ -n $me ]]; then
        echo "%{$fg[$HOST_ME]%}$me%{$reset_color%}:"
    fi
}

function __directory() {
  echo "%{$fg[$CURRENT_DIR]%}%c%{$reset_color%}:"
}

function __git_status() {
    local message=""
    local message_color="%F{$GIT_STATUS_DEFAULT}"

    # https://git-scm.com/docs/git-status#_short_format
    local staged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU]")
    local unstaged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU? ][MADRCU?]")

    if [[ -n ${staged} ]]; then
        message_color="%F{$GIT_STATUS_STAGED}"
    elif [[ -n ${unstaged} ]]; then
        message_color="%F{$GIT_STATUS_UNSTAGED}"
    fi

    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n ${branch} ]]; then
        message+="${message_color}${branch}%f"
    fi

    echo -n "${message}"
}

function __return_symbol() {
  echo -n " %(?.%F{$RETURN_STATUS_TRUE}.%F{$RETURN_STATUS_FALSE})$PROMPT_SYMBOL%f "
}

function __show_status() {
    exit_status=${pipestatus[*]}
    local SETCOLOR_DEFAULT="%F{green}"
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
        echo -ne "${SETCOLOR}(${exit_status// /|})"
    else
        echo -ne "${SETCOLOR}"
    fi
}

PROMPT='[$(__host):$(__directory):$(__git_status)]${WINDOW:+"[$WINDOW]"}$(__return_symbol)'
RPROMPT='$(__show_status)'
