# startup
fpath=($HOME/.zsh/completion $fpath)

# important
setopt prompt_subst
for f in $HOME/.zsh/*.zsh; do
    source $f;
done;

for file in ~/.{exports,aliases,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

autoload -Uz compinit && compinit -i
# quick hack to remove green background
eval "$(dircolors -p | sed 's/ 4[0-9];/ 01;/; s/;4[0-9];/;01;/g; s/;4[0-9] /;01 /' | dircolors /dev/stdin)"
HISTFILE=~/.histfile
HISTSIZE=2500
SAVEHIST=2500

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

eval "$(dircolors $HOME/.dircolors)"
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma/fast-syntax-highlighting \
    zdharma/history-search-multi-word \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

# fzf
zinit ice from"gh-r" as"program"
zinit load junegunn/fzf-bin

# tab completions
zinit ice wait"0b" lucid blockf
zinit light zsh-users/zsh-completions
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:descriptions' format '-- %d --'
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:complete:*:options' sort false
zstyle ':fzf-tab:complete:_zlua:*' query-string input
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm,cmd -w -w"
zstyle ':fzf-tab:complete:kill:argument-rest' extra-opts --preview=$extract'ps --pid=$in[(w)1] -o cmd --no-headers -w -w' --preview-window=down:3:wrap
zstyle ':fzf-tab:complete:cd:*' extra-opts --preview=$extract'exa -1 --color=always ${~ctxt[hpre]}$in'

# geometry
# zinit ice pick"geometry.zsh"
# zinit light geometry-zsh/geometry

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
zinit light romkatv/powerlevel10k
# dark version
zinit snippet https://github.com/sainnhe/dotfiles/raw/master/.zsh-theme-gruvbox-material-dark
zinit load 'wfxr/forgit'
### End of Zinit's installer chunk

# [[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx -- vt1 &> /dev/null
# run xinit
if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/aarnphm/google-cloud-sdk/path.zsh.inc' ]; then . '/home/aarnphm/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/aarnphm/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/aarnphm/google-cloud-sdk/completion.zsh.inc'; fi
