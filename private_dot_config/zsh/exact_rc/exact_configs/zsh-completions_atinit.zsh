autoload -Uz add-zle-hook-widget
if ! builtin command -v compinit > /dev/null 2>&1; then
  autoload -Uz compinit
  if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
    compinit
  else
    compinit -C
  fi
fi

if [[ -d /opt/ros/melodic ]]; then
    source /opt/ros/melodic/setup.zsh
fi
