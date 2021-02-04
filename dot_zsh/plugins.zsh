source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# syntax highlighting and completion
zinit wait lucid light-mode for \
    atinit"zicompinit; zicdreplay" zdharma/fast-syntax-highlighting

# search through long list of commands with Ctrl+R
zplugin light zdharma/history-search-multi-word

