# force dircolors 
if [[ -f ~/.dircolors ]];
 then 
    eval $(dircolors -b ~/.dircolors)
 elif [[ -f /etc/DIR_COLORS ]]; 
 then 
    eval $(dircolors -b /etc/DIR_COLORS)
 fi
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=2500
SAVEHIST=2500
bindkey -v
# Load completion config
source $HOME/.zsh/completion.zsh

# source file from bashrc, have $PATH variable in ~/.bash_profile
# alias in ~/.bashrc and others already in bash (compatability)
# backward compatability when transfer from bash to zsh
source ~/.bashrc

# added tmux to zsh when startup
if [ -z "$TMUX" ]
then
    tmux attach -t TMUX || tmux new -s TMUX
fi

# Added fzf with rg

# source zprezto
source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
 
# autoload -Uz compinit && compinit -i
# zmodload -i zsh/complist

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
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-bin-gem-node
zinit load zdharma/history-search-multi-word
zinit light zsh-users/zsh-syntax-highlighting

# End of Zinit's installer chunk

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/aar0npham/google-cloud-sdk/path.zsh.inc' ]; then . '/home/aar0npham/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/aar0npham/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/aar0npham/google-cloud-sdk/completion.zsh.inc'; fi
if command -v minikube &>/dev/null;
then
  eval "$(minikube completion zsh)";
fi;

if command -v pyenv 1>/dev/null 2>&1; 
then
    eval "$(pyenv init -)";
fi;
# eval "$(starship init zsh)"
