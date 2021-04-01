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

# Enable aliases to be sudo’ed
alias sudo='nocorrect sudo'

# git
alias g="git"
alias vig="e $XDG_CONFIG_HOME/git/gitignore"

if (( $+commands[protonvpn] )); then
    alias vpnconnect="sudo protonvpn connect --cc CA"
    alias vpndisconnect="sudo protonvpn disconnect"
    alias vpnstatus="sudo protonvpn status"
fi

# List all files colorized in long format
if command -v virt-what &>/dev/null; then
    alias la="\ls --color -rthla --group-directories-first"
else
    # la is actually exa
    alias la="ls ${LS_OPTS} ${colorflag}"
fi
# nnn intensifies
alias N="sudo -E nnn -dDH"
alias l="n"
alias lp="nnn -P p"

# editors
alias v="$EDITOR $@"
alias av="$EDITOR -p $@"

#chmod
alias 644='chmod 644'
alias 600='chmod 600'
alias 755='chmod 755'
alias 700='chmod 700'
alias 777='chmod 777'
alias cx='chmod +x'

#==============================================================#
## Global alias
#==============================================================#

alias -g G='| grep '  # e.x. dmesg lG CPU
alias -g L='| $PAGER '
alias -g W='| wc'
alias -g H='| head'
alias -g T='| tail'

#==============================================================#
## Suffix
#==============================================================#

alias -s {md,markdown,txt}="$EDITOR"
alias -s {html,gif,mp4}='x-www-browser'
alias -s rb='ruby'
alias -s py='python'
alias -s hs='runhaskell'
alias -s php='php -f'
alias -s {jpg,jpeg,png,bmp}='feh'
alias -s mp3='mplayer'
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
## Chezmoi
#==============================================================#

# move to functions
alias dots="cd $CHEZMOI_DIR"

# editor
alias e="$CHEZMOI_BIN edit --apply $@"
alias ca="source $ZDOTDIR/.zshenv.local && $CHEZMOI_BIN apply ${CHEZMOI_OPTS}"
alias dca="source $ZDOTDIR/.zshenv.local && $CHEZMOI_BIN apply ${CHEZMOI_OPTS_DRY}"
alias chez-add="chezmoi add ${CHEZMOI_OPTS}"

#==============================================================#
## Dir
#==============================================================#

alias cs="cd $CS_PATH"
# mcmaster vpn connect via studentvpn.mcmaster.ca
if [[ -d $CS_PATH/mcmaster ]]; then
    alias compeng="$CS_PATH/mcmaster && `\ls -t $CS_PATH/mcmaster | egrep 'compeng' | head -n1`"
fi
alias chezmoidir="cd $CS_PATH/chezmoi"
# bentoml
alias bentodir="cd $CS_PATH/BentoML"
# luxcer
alias luxcer="cd $CS_PATH/luxcer"
# zsh config directory
alias simpledir="cd $CS_PATH/simple"
alias simup="cp $ZRCDIR/simple/*.zsh $CS_PATH/simple/"
alias zcdir="cd $CHEZMOI_DIR/private_dot_config/exact_zsh/exact_rc"
alias zdir="cd $CHEZMOI_DIR/dot_zsh"
# vim config
alias vdir="cd $CHEZMOI_DIR/private_dot_config/vim"
alias vconf="$EDITOR $CHEZMOI_DIR/private_dot_config/vim/exact_rcs"
# awesome config
alias adir="cd $CHEZMOI_DIR/private_dot_config/exact_awesome"
alias aconf="$EDITOR -p $CHEZMOI_DIR/private_dot_config/exact_awesome/*.lua"
alias awet="awmtt start -C $XDG_CONFIG_HOME/awesome/rc.lua.test"

#==============================================================#
## App
#==============================================================#

# bento
alias bento="bentoml $@"
# odoo
alias odoo="${ODOO_PATH}/odoo-bin ${ODOO_OPTS}"
# jupyter
alias ipynb="jupyter notebook ${JUPYTER_OPTS}"

# check internet
alias speedtest="watch -n 1 ping -c 1 google.com"
alias delay="ping google.com | grep -E --only-matching --color '[0-9\.]+ ms'"

# IP addresses
alias ip4='dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com'
alias ip6='dig TXT +short o-o.myaddr.l.google.com @ns1.google.com'
alias dlisten='ss -lntu | grep $1'
alias copy='xclip -sel clip'
alias bwpass='[[ -f $HOME/bw.pass ]] && cat $HOME/bw.pass | sed -n 1p | xclip -sel clip'

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
    alias pac-update='sudo pacman -Sy'
    alias pac-upgrade='sudo pacman -Syu'
    alias pac-upgrade-force='sudo pacman -Syyu'
    alias pac-install='sudo pacman -S'
    alias pac-remove='sudo pacman -Rs'
    # search remote package
    alias pac-search='pacman -Ss'
    alias pac-package-info='pacman -Si'
    # search local package
    alias pac-installed-list='pacman -Qs'
    alias pac-installed-package-info='pacman -Qi'
    # import: sudo pacman -S pkglist.txt
    alias pac-installed-list-export='pacman -Qqen'
    alias pac-installed-files='pacman -Ql'
    alias pac-unused-list='pacman -Qtdq'
    alias pac-search-from-path='pacman -Qqo'
    # search package from filename
    alias pac-included-files='pacman -Fl'
    alias pac-search-by-filename='pkgfile'
    # log
    alias pac-log='cat /var/log/pacman.log | \grep "installed\|removed\|upgraded"'
    alias pac-aur-packages='pacman -Qm'
    # etc
    alias pac-clean='sudo pacman -Sc'
    # aur
    if builtin command -v yay > /dev/null 2>&1; then
        alias yay-installed-list='yay -Qm'
        alias yay-clean='yay -Sc'
        alias yay-update='yay -Syuu --noconfirm'
    fi
fi

# systemctl related
if (( $+commands[systemctl] )); then
    alias sys-restart='sudo systemctl restart'
    alias sys-start='sudo systemctl start'
    alias sys-stop='sudo systemctl stop'
    alias sys-enable='sudo systemctl enable'
    alias sys-disable='sudo systemctl disable'
    alias sys-restart='sudo systemctl restart'
    alias sys-reload='sudo systemctl reload'
    alias sys-status='systemctl status'
    alias sys-show='systemctl show'
    alias sys-lu='systemctl list-units'
    alias sys-luf='systemctl list-unit-files'
    alias sys-lt='systemctl list-timers'
    alias sys-cat='systemctl cat'
    alias sys-ie='systemctl is-enabled'
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
alias path='echo -e ${PATH//:/\\n}'
alias fpath='echo -e ${FPATH//:/\\n}'

# File Download
if (( $+commands[curl] )); then
    alias get='curl --continue-at - --location --progress-bar --remote-name --remote-time'
elif (( $+commands[wget] )); then
    alias get='wget --continue --progress=bar --timestamping'
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
