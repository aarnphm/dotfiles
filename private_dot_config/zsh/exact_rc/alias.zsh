#!/usr/bin/env zsh

#==============================================================#
## Aliases
#==============================================================#

# Reload the shell (i.e. invoke as a login shell (-l))
alias reload="exec -l ${SHELL}"
# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"

#==============================================================#
## Chezmoi
#==============================================================#

# move to functions
alias dots="cd $CHEZMOI_DIR"

# editor
alias e="$CHEZMOI_BIN edit --apply"
alias ca="$CHEZMOI_BIN apply ${CHEZMOI_OPTS}"
alias dca="$CHEZMOI_BIN apply ${CHEZMOI_OPTS_DRY}"
alias sca="source $ZDOTDIR/.zshenv.local && $CHEZMOI_BIN apply ${CHEZMOI_OPTS}"
alias dsca="source $ZDOTDIR/.zshenv.local && $CHEZMOI_BIN apply ${CHEZMOI_OPTS_DRY}"

# Enable aliases to be sudo’ed
alias sudo="nocorrect sudo"

# git
alias g="git"
alias vig="e $XDG_CONFIG_HOME/git/gitignore"
alias dm="$EDITOR $(dirname "$(git config --global --get include.path)")/dot-commit-msg"
alias triple=". $HOME/.config/screenlayout/triple.sh"

if (( $+commands[protonvpn] )); then
    alias vpnconnect="sudo protonvpn connect --cc CA"
    alias vpndisconnect="sudo protonvpn disconnect"
    alias vpnstatus="sudo protonvpn status"
fi

# List all files colorized in long format
if command -v virt-what &>/dev/null; then
    alias la="\ls --color -rthla --group-directories-first"
else
    # exa as defaults
    alias la="exa ${LS_OPTS} ${colorflag}"
fi
# nnn intensifies
alias N="sudo -E nnn -dDH"
alias l="n"
alias lp="nnn -P p"

# editors
alias v="$EDITOR"
alias av="$EDITOR -p"

#chmod
alias 644="chmod 644"
alias 600="chmod 600"
alias 755="chmod 755"
alias 700="chmod 700"
alias 777="chmod 777"
alias cx="chmod +x"

#==============================================================#
## Global alias
#==============================================================#

alias -g G="| grep "  # e.x. dmesg lG CPU
alias -g L="| $PAGER "
alias -g W="| wc"
alias -g H="| head"
alias -g T="| tail"

#==============================================================#
## Suffix
#==============================================================#

alias -s {md,markdown,txt}="$EDITOR"
alias -s {html,gif,mp4}="x-www-browser"
alias -s rb="ruby"
alias -s py="python"
alias -s hs="runhaskell"
alias -s php="php -f"
alias -s {jpg,jpeg,png,bmp}="feh"
alias -s mp3="mplayer"
function extract() {
    case $1 in
        *.tar.gz|*.tgz) tar xzvf "$1";;
        *.tar.xz) tar Jxvf "$1";;
        *.zip) unzip "$1";;
        *.lzh) lha e "$1";;
        *.tar.bz2|*.tbz) tar xjvf "$1";;
        *.tar.Z) tar zxvf "$1";;
        *.gz) gzip -d "$1";;
        *.bz2) bzip2 -dc "$1";;
        *.Z) uncompress "$1";;
        *.tar) tar xvf "$1";;
        *.arj) unarj "$1";;
    esac
}
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=extract

#==============================================================#
## Dir
#==============================================================#

alias cs="cd $CS_PATH"

# awesome config
alias aconf="$EDITOR -p $CHEZMOI_DIR/private_dot_config/exact_awesome/*.lua"
alias awet="awmtt start -C $XDG_CONFIG_HOME/awesome/rc.lua.test"

#==============================================================#
## App
#==============================================================#

# jupyter
alias ipynb="jupyter notebook ${JUPYTER_OPTS}"

# check internet
alias speedtest="watch -n 1 ping -c 1 google.com"
alias delay="ping google.com | grep -E --only-matching --color '[0-9\.]+ ms'"

# IP addresses
alias ip4="dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com"
alias ip6="dig TXT +short o-o.myaddr.l.google.com @ns1.google.com"
alias dlisten="ss -lntu | grep $1"
alias freetcp="fuser -k {$@}/tcp"
alias copy="xclip -sel clip"
alias bwpass="[[ -f $HOME/bw.pass ]] && cat $HOME/bw.pass | sed -n 1p | xclip -sel clip"

# some curl ass shit
alias cryptoprice="curl rate.sx"
alias weather="curl wttr.in/$CITY"

# docker and kubectl related
alias dockerprune="docker system prune -a -f"
alias kubesecret="kubectl get secret regcred --output=yaml"

if (( $+commands[journalctl] )); then
    alias failed="journalctl -p 3 -xb"
fi

#==============================================================#
## Arch
#==============================================================#
if [ -f /etc/arch-release ] ;then
    # urxvt
    alias Xresources-reload="xrdb -remove && xrdb -DHOME_ENV=\"$HOME\" -merge ~/.config/X11/Xresources"
    # install
    alias pacupdate="sudo pacman -Sy"
    alias pacupgrade="sudo pacman -Syu"
    alias pacupgradef="sudo pacman -Syyu"
    alias pacinstall="sudo pacman -S"
    alias pacremove="sudo pacman -Rs"
    # search remote package
    alias pacsearch="pacman -Ss"
    alias packinfo="pacman -Si"
    # search local package
    alias pacinstalled="pacman -Qs"
    alias pacinstalledinfo="pacman -Qi"
    alias pacinstalledfiles="pacman -Ql"
    # import: sudo pacman -S pkglist.txt
    alias pacexport="pacman -Qqen"
    alias pacunused="pacman -Qtdq"
    alias pacsearchfrompath="pacman -Qqo"
    alias pacsearchbyfilename="pkgfile"
    # search package from filename
    alias pacincludedfiles="pacman -Fl"
    # log
    alias paclog="cat /var/log/pacman.log | \grep "installed\|removed\|upgraded""
    alias aurpack="pacman -Qm"
    # etc
    alias pacclean="sudo pacman -Sc"
    # aur
    if builtin command -v yay > /dev/null 2>&1; then
        alias ylist="yay -Qm"
        alias yclean="yay -Sc"
        alias yupdate="yay -Syuu --noconfirm"
    fi
fi

# systemctl related
if (( $+commands[systemctl] )); then
    alias sysrestart="sudo systemctl restart"
    alias sysstart="sudo systemctl start"
    alias sysstop="sudo systemctl stop"
    alias sysenable="sudo systemctl enable"
    alias sysdisable="sudo systemctl disable"
    alias sysreload="sudo systemctl reload"
    alias sysstatus="systemctl status"
    alias sysshow="systemctl show"
    alias syslu="systemctl list-units"
    alias sysluf="systemctl list-unit-files"
    alias syslt="systemctl list-timers"
    alias syscat="systemctl cat"
    alias sysie="systemctl is-enabled"
fi

alias ag="ag --color --color-line-number '0;35' --color-match '46;30' --color-path '4;36'"

alias keys="xev | grep -i key"

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# URL-encode strings
alias urlencode='python -c "import sys, urllib.parse as ul; print(ul.quote(sys.argv[1]));"'

# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
    alias "${method}"="lwp-request -m '${method}'"
done

#Lock the screen (when going AFK)
if [[ $SYSTEM == "Darwin" ]]; then
    alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
elif [[ -f /etc/arch-release ]]; then
    if xset q | grep "DPMS is Enabled" &>/dev/null; then
        alias afk="xset s activate"
    else
        alias afk="xsecurelock"
    fi
fi

# Print each PATH, FPATH entry on a separate line
# alias path="echo -e ${PATH//:/\\n}"
# alias fpath="echo -e ${FPATH//:/\\n}"

# File Download
if (( $+commands[curl] )); then
    alias get="curl --continue-at - --location --progress-bar --remote-name --remote-time"
elif (( $+commands[wget] )); then
    alias get="wget --continue --progress=bar --timestamping"
fi

#==============================================================#
## safe opts
#==============================================================#
alias tmux="TERM=xterm-256color $(which tmux) ${TMUX_OPTS}"

# Safe ops. Ask the user before doing anything destructive.
alias rmi="/usr/bin/rm -i"
alias mvi="${aliases[mv]:-mv} -i"
alias cpi="${aliases[cp]:-cp} -i"
alias lni="${aliases[ln]:-ln} -i"

#==============================================================#
## Hash
#==============================================================#

hash -d data=~/.local/share/
# vim: set ft=zsh ts=2 sw=2 tw=0 et :
