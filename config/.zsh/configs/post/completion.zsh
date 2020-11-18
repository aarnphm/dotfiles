# load our own completion functions
fpath=(~/.zsh/completion /usr/local/share/zsh/site-functions $fpath)

# source '/home/aarnphm/.pyenv/libexec/../completions/pyenv.zsh'
command pyenv rehash 2>/dev/null
pyenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  activate|deactivate|rehash|shell)
    eval "$(pyenv "sh-$command" "$@")";;
  *)
    command pyenv "$command" "$@";;
  esac
}
# Case Insensitive completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# completion; use cache if updated within 24h
autoload -Uz compinit
if [[ -n $HOME/.zcompdump(#qN.mh+24) ]]; then
  compinit -d $HOME/.zcompdump;
else
  compinit -C;
fi;
_comp_options+=(globdots)

# disable zsh bundled function mtools command mcd
# which causes a conflict.
compdef -d mcd

# The next line enables shell command completion for gcloud.
if [ -f '/home/aarnphm/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/aarnphm/google-cloud-sdk/completion.zsh.inc'; fi

# nnn
if [ -f /usr/share/nnn/quitcd/quitcd.bash_zsh ]; then
    source /usr/share/nnn/quitcd/quitcd.bash_zsh
fi
