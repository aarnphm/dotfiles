# zmodload zsh/zprof
# startup
fpath=($HOME/.zsh/completion $fpath)

# run xinit
if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi

setopt CORRECT
setopt AUTO_CD              # Auto changes to a directory without typing cd.
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME        # Push to home directory when no argument is given.
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt MULTIOS              # Write to multiple descriptors.
setopt EXTENDED_GLOB        # Use extended globbing syntax.
unsetopt CLOBBER            # Do not overwrite existing files with > and >>. Use >! and >>! to bypass.

# Dot expansions
function expand-dot-to-parent-directory-path {
  if [[ $LBUFFER = *.. ]]; then
    LBUFFER+='/..'
  else
    LBUFFER+='.'
  fi
}
zle -N expand-dot-to-parent-directory-path

autoload -Uz vcs_info
autoload -U colors && colors
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )

# eval "$(dircolors $HOME/.dircolors)"
for file in ~/.{exports,aliases,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;

# termmode: minimal, fancy
termmode=minimal
if [[ "$termmode" == "minimal" ]]; then
	setopt prompt_subst
	export PROMPT="%{$fg[yellow]%}%m %{$fg_bold[blue]%}%~%{$fg_bold[cyan]%}\$vcs_info_msg_0_ %{$reset_color%}"
	zstyle ':vcs_info:git:*' formats ' @%b'
else	
	[[ ! -f ~/.zshtheme ]] || source ~/.zshtheme
fi

autoload -Uz compinit && compinit -i

if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
      zdharma/fast-syntax-highlighting \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions

(( ${+_comps} )) && _comps[zinit]=_zinit

# The next line enables shell command completion for gcloud.
if [ -f '/home/aarnphm/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/aarnphm/google-cloud-sdk/completion.zsh.inc'; fi

# cd on quit when nnn
if [ -f /usr/share/nnn/quitcd/quitcd.bash_zsh ]; then
    source /usr/share/nnn/quitcd/quitcd.bash_zsh
fi
# zprof
