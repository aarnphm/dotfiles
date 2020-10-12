setopt correct auto_menu 
setopt autocd autopushd multios 
setopt complete_in_word
setopt pushd_ignore_dups 
setopt pushd_silent pushd_to_home cdable_vars          
setopt extendedglob

unsetopt clobber           

zstyle ':completion:*' menu select

# ============================== zinit & misc
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
# syntax highlighting and completion
zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" zdharma/fast-syntax-highlighting \
  blockf atpull'zinit creinstall -q .' zsh-users/zsh-completions

# search history via substring
zplugin light zsh-users/zsh-history-substring-search 
# search through long list of commands with Ctrl+R
zplugin ice from"gh" wait"1" silent pick"history-search-multi-word.plugin.zsh" lucid
zplugin light zdharma/history-search-multi-word

(( ${+_comps} )) && _comps[zinit]=_zinit

