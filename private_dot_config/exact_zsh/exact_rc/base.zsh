#==============================================================#
##          Base Configuration                                ##
#==============================================================#

unsetopt clobber
unsetopt hist_verify
setopt prompt_subst

setopt notify 
setopt correct auto_menu
setopt autocd autopushd multios
setopt complete_in_word
setopt pushd_ignore_dups
setopt pushd_silent pushd_to_home cdable_vars
setopt extendedglob extended_history append_history
setopt hist_reduce_blanks hist_save_no_dups hist_no_store hist_expand
setopt hist_ignore_all_dups inc_append_history

HOSTNAME="$HOST"
[[ -f $ZDATADIR/zsh_history ]] && HISTFILE="${ZDATADIR}/zsh_history"
HISTSIZE=10000
SAVEHIST=100000
HISTORY_IGNORE="(ls|cd|pwd|zsh|exit|cd ..)"
LISTMAX=1000
KEYTIMEOUT=1
WORDCHARS='*?_-.[]~&;!#$%^(){}<>|'

# autoload
autoload -Uz run-help
autoload -Uz add-zsh-hook
autoload -Uz colors && colors
autoload -Uz is-at-least

# core
ulimit -c unlimited

umask 022

export DISABLE_DEVICONS=false
