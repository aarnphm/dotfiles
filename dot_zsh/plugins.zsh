#!/usr/bin/env zsh

source "$HOME/.zinit/bin/zinit.zsh"
# autoload -Uz _zinit
# (( ${+_comps} )) && _comps[zinit]=_zinit

# syntax highlighting and completion
zinit wait lucid light-mode for \
    atinit"zicompinit; zicdreplay" zdharma/fast-syntax-highlighting

#zplugin ice wait"0" lucid
# must load it otherwise bindkeys won't work
zplugin light zsh-users/zsh-history-substring-search

zplugin ice wait"0" lucid
zplugin load zdharma/history-search-multi-word
