# support for autocompletion
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i
# force dircolors if have one 
if [[ -f ~/.dircolors ]];
then 
	eval "$(dircolors -b ~/.dircolors)"
fi

HISTFILE=~/.histfile
HISTSIZE=2500
SAVEHIST=2500
bindkey -v

# added tmux to zsh when startup
if [ -z "$TMUX" -a ! $(uname -r | cut -c10-18) = "microsoft" ]
then
    tmux attach -t TMUX || tmux new -s TMUX
fi

# source zprezto
source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

# some slight modification 
if [[ "$OSTYPE"=="linux-gnu"* ]];then
	source ~/.zsh-theme-gruvbox-material-*
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
elif [ $(uname -r | cut -c10-18) = "microsoft" ];then 
	source ~/.zsh/.p10k.zsh
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

zinit load zdharma/history-search-multi-word
zinit light zdharma/fast-syntax-highlighting

# dark version
# zinit snippet https://github.com/sainnhe/dotfiles/raw/master/.zsh-theme-gruvbox-material-dark
### End of Zinit's installer chunk

if command -v starship &>/dev/null; then
	eval "$(starship init zsh)"
fi;

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/aar0npham/dotfiles/google-cloud-sdk/path.zsh.inc' ]; then . '/home/aar0npham/dotfiles/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/aar0npham/dotfiles/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/aar0npham/dotfiles/google-cloud-sdk/completion.zsh.inc'; fi
