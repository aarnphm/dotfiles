#==============================================================#
##          Base Configuration                                ##
#==============================================================#

HOSTNAME="$HOST"
HISTFILE="${ZDATADIR}/zsh_history"
HISTSIZE=10000
SAVEHIST=100000
HISTORY_IGNORE="(ls|cd|pwd|zsh|exit|cd ..)"
LISTMAX=1000
KEYTIMEOUT=1
WORDCHARS='*?_-.[]~&;!#$%^(){}<>|'

cdpath=("$HOME" .. $HOME/*)

# autoload
autoload -Uz run-help
autoload -Uz add-zsh-hook
autoload -Uz colors && colors
autoload -Uz is-at-least

# core
ulimit -c unlimited

# sipmle colors
if [ $SYSTEM = "Linux" ]; then
    zstyle ':prompt:simple:prompt:success' color 222
fi

umask 022

export DISABLE_DEVICONS=false
