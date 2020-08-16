# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{exports,aliases,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

source "$HOME/.zinit/bin/zinit.zsh"
# support for autocompletion
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i
# quick hack to remove green background
eval "$(dircolors -p | \
    sed 's/ 4[0-9];/ 01;/; s/;4[0-9];/;01;/g; s/;4[0-9] /;01 /' | \
    dircolors /dev/stdin)"
HISTFILE=~/.histfile
HISTSIZE=2500
SAVEHIST=2500

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

# Load without investigating
zinit light zdharma/fast-syntax-highlighting
zinit light zsh-users/zsh-au+tosuggestions

# Load with investigating
zinit load zdharma/history-search-multi-word
# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

if command -v starship &>/dev/null; then
	eval "$(starship init zsh)"
fi;

source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

#The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/aarnphm/google-cloud-sdk/path.zsh.inc' ]; then . '/home/aarnphm/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/aarnphm/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/aarnphm/google-cloud-sdk/completion.zsh.inc'; fi
