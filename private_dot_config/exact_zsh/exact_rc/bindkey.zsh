#==============================================================#
##          Key Bindings                                      ##
#==============================================================#

stty intr '^C'
stty susp '^Z'
stty stop undef
bindkey -v     # vi 風

## delete ##
bindkey '^?'    backward-delete-char
bindkey '^H'    backward-delete-char
bindkey '^[[3~' delete-char
bindkey '^[[3;5~' delete-word

## jump ##
bindkey  '^[[H' beginning-of-line
bindkey  '^[[F' end-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[7~' beginning-of-line
bindkey '^[[8~' end-of-line
bindkey '^U' backward-kill-line
bindkey '^[^?' delete-char-or-list

## move ##
bindkey '^[h' backward-char
bindkey '^[j' down-line-or-history
bindkey '^[k' up-line-or-history
bindkey '^[l' forward-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

## history ##
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[p" history-beginning-search-backward
bindkey "^[n" history-beginning-search-forward
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward
autoload -Uz smart-insert-last-word
zstyle :insert-last-word match '*([[:alpha:]/\\]?|?[[:alpha:]/\\])*'
zle -N insert-last-word smart-insert-last-word
function _insert-last-word() { smart-insert-last-word; ARG=-2 }
zle -N _insert-last-word
bindkey '^]' _insert-last-word
function insert-next-word() { zle insert-last-word -- 1 -1; ARG=-2 }
zle -N insert-next-word
bindkey '^_' insert-next-word
function zle-line-finish() { ARG=-2 }
zle -N zle-line-finish
function insert-prev-arg() { zle insert-last-word -- 0 ${ARG:-2}; ARG=$(($ARG-1)) }
zle -N insert-prev-arg
bindkey '^^' insert-prev-arg
bindkey '\e#' pound-insert

## completion ##
# shift-tab
zmodload zsh/complist
bindkey '^[[Z' reverse-menu-complete
bindkey -M menuselect '^[[Z' reverse-menu-complete

## edit ##
# copy command
zle -N pbcopy-buffer
bindkey '^X^Y' pbcopy-buffer
bindkey '^Xy' pbcopy-buffer
bindkey '^[u' undo
bindkey '^[r' redo

# edit command-line using editor (like fc command)
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
bindkey -s "^T" "^[Isudo ^[A" # "t" for "toughguy"

## etc ##
bindkey '^X*' expand-word
# stack command
zle -N show_buffer_stack

