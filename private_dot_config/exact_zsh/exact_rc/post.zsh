if ! builtin command -v compinit > /dev/null 2>&1; then
    autoload -Uz compinit && compinit -u
fi
# eval "$(/home/aarnphm/anaconda3/bin/conda shell.zsh hook)"
