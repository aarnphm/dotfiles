# run xinit
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    exec startx
fi

for function in $HOME/.zsh/functions/*; do
    source $function
done

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

zstyle ':completion:*' menu select

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

# syntax highlighting and completion
zinit wait lucid light-mode for \
    atinit"zicompinit; zicdreplay" zdharma/fast-syntax-highlighting

# search through long list of commands with Ctrl+R
zplugin light zdharma/history-search-multi-word

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases
