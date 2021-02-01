# #!/usr/bin/env zsh
# profiling
# zmodload zsh/zprof

# run xinit
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    exec startx
fi

# load our own completion functions
zfunc=${HOME}/.zsh/functions
fpath=(~/.zsh/completion /usr/local/share/zsh/site-functions $zfunc $fpath)

for function in $zfunc/*; do
    autoload -Uz ${function:t}
done
unset zfunc

# extra files in ~/.zsh/configs/pre , ~/.zsh/configs , and ~/.zsh/configs/post
# these are loaded first, second, and third, respectively.
_load_settings() {
    _dir="$1"
    if [ -d "$_dir" ]; then
        if [ -d "$_dir/pre" ]; then
            for config in "$_dir"/pre/**/*~*.zwc(N-.); do
                . $config
            done
        fi

        for config in "$_dir"/**/*(N-.); do
            case "$config" in
                "$_dir"/(pre|post)/*|*.zwc)
                    :
                    ;;
                *)
                    . $config
                    ;;
            esac
        done

        if [ -d "$_dir/post" ]; then
            for config in "$_dir"/post/**/*~*.zwc(N-.); do
                . $config
            done
        fi
    fi
}

_load_settings "$HOME/.zsh/configs"

# Start ssh-agent
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! "$SSH_AUTH_SOCK" ]]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# .localrc contains all the local dev variables
[[ -f ~/.localrc ]] && source ~/.localrc

# zprof
