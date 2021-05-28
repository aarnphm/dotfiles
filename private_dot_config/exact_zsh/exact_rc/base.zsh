#==============================================================#
##          Base Configuration                                ##
#==============================================================#
HOSTNAME="$HOST"
[[ -f $ZDATADIR/zsh_history ]] && HISTFILE="${ZDATADIR}/zsh_history" || touch $ZDATADIR/zsh_history
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

unsetopt clobber
unsetopt hist_verify
setopt prompt_subst

setopt notify 
setopt correct 
setopt auto_menu
setopt autocd 
setopt autopushd 
setopt multios
setopt complete_in_word
setopt pushd_ignore_dups
setopt pushd_silent 
setopt pushd_to_home 
setopt cdable_vars
setopt extendedglob 
setopt extended_history 
setopt append_history 
setopt share_history
setopt hist_reduce_blanks 
setopt hist_save_no_dups 
setopt hist_no_store 
setopt hist_expand
setopt hist_ignore_all_dups 
setopt inc_append_history
