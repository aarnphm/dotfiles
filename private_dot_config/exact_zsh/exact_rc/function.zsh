#==============================================================#
##         Override Commands                                  ##
#==============================================================#

###     history     ###
function history-all() {
    history -E 1
}

function __exec_command_with_tmux() {
    local cmd="$@"
    if [[ "$(ps -p $(ps -p $$ -o ppid=) -o comm= 2> /dev/null)" =~ tmux ]]; then
        if [[ $(tmux show-window-options -v automatic-rename) != "off" ]]; then
            local title=$(echo "$cmd" | cut -d ' ' -f 2- | tr ' ' '\n'  | grep -v '^-' | sed '/^$/d' | tail -n 1)
            if [ -n "$title" ]; then
                tmux rename-window -- "$title"
            else
                tmux rename-window -- "$cmd"
            fi
            trap 'tmux set-window-option automatic-rename on 1>/dev/null' 2
            eval command "$cmd"
            local ret="$?"
            tmux set-window-option automatic-rename on 1>/dev/null
            return $ret
        fi
    fi
    eval command "$cmd"
}

###     ssh      ###
function ssh() {
    local args=$(printf ' %q' "$@")
    local ppid=$(ps -p $$ -o ppid= 2> /dev/null | tr -d ' ')
    if [[ "$@" =~ .*BatchMode=yes.*ls.*-d1FL.* ]]; then
        command ssh "$args"
        return
    fi

    case $TERM in
        *xterm*|rxvt*|(dt|k|E)term|*kitty*|screen*)
            print -Pn "\e]2;ssh $@\a"
            ;;
    esac

    __exec_command_with_tmux "ssh $args"
}

function which () {
    (alias; declare -f) | /usr/bin/which --tty-only --read-alias --read-functions --show-tilde --show-dot $@
}

### echo ###
function print_default() {
    echo -e "$*"
}

function print_info() {
    echo -e "\e[1;36m$*\e[m" # cyan
}

function print_notice() {
    echo -e "\e[1;35m$*\e[m" # magenta
}

function print_success() {
    echo -e "\e[1;32m$*\e[m" # green
}

function print_warning() {
    echo -e "\e[1;33m$*\e[m" # yellow
}

function print_error() {
    echo -e "\e[1;31m$*\e[m" # red
}

function print_debug() {
    echo -e "\e[1;34m$*\e[m" # blue
}

#==============================================================#
##         Override Shell Functions                           ##
#==============================================================#

###     copy     ###
function pbcopy() {
    local input
    if [ -p /dv/stdin ]; then
        if [ "`echo $@`" == "" ]; then
            input=`cat -`
        else
            input=$@
        fi
    else
        input=$@
    fi
    if [ "$WAYLAND_DISPLAY" != "" ]; then
        if builtin command -v wl-copy > /dev/null 2>&1; then
            echo -n $input | wl-copy
        fi
    else
        if builtin command -v xsel > /dev/null 2>&1; then
            echo -n $input | xsel -i --primary
            echo -n $input | xsel -i --clipboard
        elif builtin command -v xclip > /dev/null 2>&1; then
            echo -n $input | xclip -i -selection primary
            echo -n $input | xclip -i -selection clipboard
        fi
    fi
}

###     paste     ###
function pbpaste() {
    if builtin command -v xsel > /dev/null 2>&1; then
        xsel -o --clipboard
    elif builtin command -v xclip > /dev/null 2>&1; then
        xclip -o clipboard
    fi
}

###     copy buffer     ###
function pbcopy-buffer() {
    print -rn $BUFFER | pbcopy
    zle -M "pbcopy: ${BUFFER}"
}

###     stack command     ###
function show_buffer_stack() {
    POSTDISPLAY="
    stack: $LBUFFER"
    zle push-line-or-edit
}

function precmd_prompt() {
    [[ -t 1 ]] || return
    case $TERM in
        *xterm*|rxvt*|(dt|k|E)term|*kitty*|screen*)
            print -Pn "\e]2;[%n@%m %d]\a"
            ;;
    esac
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd precmd_prompt

#==============================================================#
##         New Commands                                      ##
#==============================================================#

# move bottom
function blank() {
    local count=10
    if [[ $@ -eq 0 ]]; then
        count=$(($(stty size | cut -d' ' -f1)/2))
    else
        count=$1
    fi
    for i in $(seq $count); do
        echo
    done
}

function comment(){
    sed -i "$1"' s/^/#/' "$2"
}

function 256color() {
    for code in {000..255}; do
        print -nP -- "%F{$code}$code %f";
        if [ $((${code} % 16)) -eq 15 ]; then
            echo ""
        fi
    done
}

function ascii_color_code() {
    seq 30 47 | xargs -n 1 -i{} printf "\x1b[%dm#\x1b[0m %d\n" {} {}
}


function find_no_new_line_at_end_of_file() {
    find * -type f -print0 | xargs -0 -L1 bash -c 'test "$(tail -c 1 "$0")" && echo "No new line at end of $0"'
}


function change_terminal_title() {
    if typeset -f precmd > /dev/null; then
        unfunction precmd
    fi
    if [ "$#" -gt 0 ]; then
        echo -ne "\033]0;$@\007"
        return
    fi
    echo "Please reload zsh"
}

function get_stdin_and_args() {
    local __str
    if [ -p /dev/stdin ]; then
        if [ "`echo $@`" == "" ]; then
            __str=`cat -`
        else
            __str="$@"
        fi
    else
        __str="$@"
    fi
    echo "$__str"
}

function ltrim() {
    local input
    input=$(get_stdin_and_args "$@")
    printf "%s" "`expr "$input" : "^[[:space:]]*\(.*[^[:space:]]\)"`"
}

function rtrim() {
    local input
    input=$(get_stdin_and_args "$@")
    printf "%s" "`expr "$input" : "^\(.*[^[:space:]]\)[[:space:]]*$"`"
}

function trim() {
    local input
    input=$(get_stdin_and_args "$@")
    printf "%s" "$(rtrim "$(ltrim "$input")")"
}

function trim_all_whitespace() {
    local input
    input=$(get_stdin_and_args "$@")
    echo "$input" | tr -d ' '
}

function convert_ascii_to_hex() {
    echo -n "$@" | xxd -ps -c 200
}

function convert_hex_to_ascii() {
    echo -n "$@" | xxd -ps -r
}

function convert_hex_to_formatted_hex() {
    echo -n "$@" | sed 's/[[:xdigit:]]\{2\}/\\x&/g'
}


function zsh-profiler() {
    ZSHRC_PROFILE=1 zsh -i -c zprof
}

function zsh-detailed() {
    logf=$(ls -tm $ZDATADIR/logs | head -n 1)
    sed -E -n '/PROFILE_STARTUP/s/false/true/' $ZDOTDIR/.zshrc
    dtime="$HOME/.local/bin/sort-timings-zsh $ZDATADIR/logs/$logf | head"
    builtin emulate zsh -i -c $dtime
}

function timeshell() {
    for i in $(seq 1 10); do time $SHELL -i -c exit; done
}

## nnn ##
function nnn-preview(){
    # Block nesting of nnn in subshells
    if [ -n "$NNNLVL" ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # This will create a fifo where all nnn selections will be written to
    NNN_FIFO="$(mktemp --suffix=-nnn -u)"
    export NNN_FIFO
    (umask 077; mkfifo "$NNN_FIFO")

    # Preview command
    preview_cmd="$HOME/.local/bin/nnn-preview-cmd"

    # Use `tmux` split as preview
    if [ -e "${TMUX%%,*}" ]; then
        tmux split-window -e "NNN_FIFO=$NNN_FIFO" -dh "$preview_cmd"

    # Use `alacritty` as a preview window
elif (which termite &> /dev/null); then
    termite --exec="$preview_cmd"

    # Unable to find a program to use as a preview window
else
    echo "unable to open preview, please install tmux or termite"
    fi

    nnn "$@"

    rm -f "$NNN_FIFO"
}

n ()
{
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
        . "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
# tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
function tre() {
    tree -aC -I $(cat $XDG_CONFIG_HOME/git/gitignore | egrep -v "^#.*$|^[[:space:]]*$" | tr "\\n" "|") --dirsfirst "$@" | less -FRX;
}

hash git &>/dev/null;
if [ $? -eq 0 ]; then
    function diff() {
        git diff --no-index --color-words "$@";
    }
fi;

## docker ##
function dockerclean {
    # remove first none images
    docker rmi -f $(docker images -a | grep "^<none>" | awk '{print $3}') 2> /dev/null;
    # now remove none container
    docker rmi -f $(docker ps -a -f status=exited -q) 2> /dev/null;
}

# Select a docker container to remove
function drm() {
    local cid
    cid=$(docker ps -a | sed 1d | fzf -q "$1" | awk '{print $1}')

    [ -n "$cid" ] && docker rm "$cid"
}

# Select a running docker container to stop
function ds() {
    local cid
    cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')

    [ -n "$cid" ] && docker stop "$cid"
}

# Load .env file into shell session for environment variables

function envup() {
    if [ -f .env ]; then
        export $(sed '/^ *#/ d' .env)
    else
        echo 'No .env file found' 1>&2
        return 1
    fi
}

# Displays user owned processes status.
function psu {
    ps -U "${1:-$LOGNAME}" -o 'pid,%cpu,%mem,command' "${(@)argv[2,-1]}"
}

# Create a new directory and enter it
function mkd() {
    mkdir -p "$@" && cd "$_";
}

function listen {
    sudo lsof -iTCP:"$@" -sTCP:LISTEN;
}

# Determine size of a file or total size of a directory
function fs() {
    if du -b /dev/null > /dev/null 2>&1; then
        local arg=-sbh;
    else
        local arg=-sh;
    fi
    if [[ -n "$@" ]]; then
        du $arg -- "$@";
    else
        du $arg .[^.]* ./*;
    fi;
}

function fe(){
    current_dir=`pwd`;
    [[ -x `builtin command -v firefox` ]] &&${BROWSER:=firefox} --new-window file://$current_dir
}