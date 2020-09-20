# zmodload zsh/zprof
# ============================== Startup
fpath=($HOME/.zsh/completion $fpath)

# run xinit
if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi

setopt correct              # You are correct
setopt pushd_ignore_dups    # Do not store duplicates in the stack.
setopt pushd_silent         # Do not print the directory stack after pushd or popd.
setopt pushd_to_home        # Push to home directory when no argument is given.
setopt cdable_vars          # Change directory to a path stored in a variable.
setopt multios              # Write to multiple descriptors.
setopt extended_glob        # Use extended globbing syntax.
unsetopt clobber            # Do not overwrite existing files with > and >>. Use >! and >>! to bypass.

# Dot expansions
function expand-dot-to-parent-directory-path {
  if [[ $LBUFFER = *.. ]]; then
    LBUFFER+='/..'
  else
    LBUFFER+='.'
  fi
}
zle -N expand-dot-to-parent-directory-path

# eval "$(dircolors $HOME/.dircolors)"

for file in ~/.{exports,aliases,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;

# ============================== Prompt
setopt prompt_subst
# autoload -Uz vcs_info
# autoload -U colors && colors

# Prompt symbol
COMMON_PROMPT_SYMBOL="❯"

# termmode: minimal, gimin, fancy
termmode=minimal

# Colors
COMMON_COLORS_HOST_ME=green
COMMON_COLORS_HOST_AWS_VAULT=yellow
COMMON_COLORS_CURRENT_DIR=blue
COMMON_COLORS_RETURN_STATUS_TRUE=yellow
COMMON_COLORS_RETURN_STATUS_FALSE=red
COMMON_COLORS_GIT_STATUS_DEFAULT=green
COMMON_COLORS_GIT_STATUS_STAGED=red
COMMON_COLORS_GIT_STATUS_UNSTAGED=yellow
COMMON_COLORS_GIT_PROMPT_SHA=green
COMMON_COLORS_BG_JOBS=yellow


# Left Prompt
PROMPT='$(common_host)$(common_current_dir)$(common_git_status)$(common_return_status)'

# Host
common_host() {
	if [[ -n $SSH_CONNECTION ]]; then
   		me="%n@%m"
  	elif [[ $LOGNAME != $USER ]]; then
    	me="%n"
  	fi
  	if [[ -n $me ]]; then
    	echo "%{$fg[$COMMON_COLORS_HOST_ME]%}$me%{$reset_color%}:"
 	fi
}

# Current directory
common_current_dir() {
  echo -n "%{$fg[$COMMON_COLORS_CURRENT_DIR]%}%c "
}

# Prompt symbol
common_return_status() {
  echo -n " %(?.%F{$COMMON_COLORS_RETURN_STATUS_TRUE}.%F{$COMMON_COLORS_RETURN_STATUS_FALSE})$COMMON_PROMPT_SYMBOL%f "
}

# Git status
common_git_status() {
    local message=""
    local message_color="%F{$COMMON_COLORS_GIT_STATUS_DEFAULT}"

    # https://git-scm.com/docs/git-status#_short_format
    local staged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU]")
    local unstaged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU? ][MADRCU?]")

    if [[ -n ${staged} ]]; then
        message_color="%F{$COMMON_COLORS_GIT_STATUS_STAGED}"
    elif [[ -n ${unstaged} ]]; then
        message_color="%F{$COMMON_COLORS_GIT_STATUS_UNSTAGED}"
    fi

    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n ${branch} ]]; then
        message+="${message_color}${branch}%f"
    fi

    echo -n "${message}"
}

# ============================== Completion
unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on successive tab press
setopt complete_in_word
setopt always_to_end
zstyle ':completion:*' menu select

autoload -Uz compinit
compinit -C
_comp_options+=(globdots)

# Case Insensitive completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

## Directory navigation
setopt autocd autopushd

# ============================== History
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
# autoload -Uz compinit && compinit -i

# vim binding
bindkey -v

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

if [[ "$termmode" == "fancy" ]]; then
	[[ ! -f ~/.zshtheme ]] || source ~/.zshtheme
	zplugin light romkatv/powerlevel10k
fi

(( ${+_comps} )) && _comps[zinit]=_zinit

# The next line enables shell command completion for gcloud.
if [ -f '/home/aarnphm/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/aarnphm/google-cloud-sdk/completion.zsh.inc'; fi

# nnn
if [ -f /usr/share/nnn/quitcd/quitcd.bash_zsh ]; then
    source /usr/share/nnn/quitcd/quitcd.bash_zsh
fi

# zprof
