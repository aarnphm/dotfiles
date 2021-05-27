#!/usr/bin/env zsh
#==============================================================#
## Setup zinit                                                ##
#==============================================================#
if [ -z "$ZPLG_HOME" ]; then
    ZPLG_HOME="$ZDATADIR/zinit"
fi

if ! test -d "$ZPLG_HOME"; then
    mkdir -p "$ZPLG_HOME"
    chmod g-rwX "$ZPLG_HOME"
    git clone https://github.com/zdharma/zinit.git ${ZPLG_HOME}/bin
fi

typeset -gAH ZPLGM
ZPLGM[HOME_DIR]="${ZPLG_HOME}"
source "$ZPLG_HOME/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

#==============================================================#
## Plugin load                                                ##
#==============================================================#

#--------------------------------#
# zinit extension
#--------------------------------#
zinit light-mode for \
    @zinit-zsh/z-a-readurl \
    @zinit-zsh/z-a-bin-gem-node

#--------------------------------#
# completion
#--------------------------------#
# syntax highlighting and completion
zinit wait lucid light-mode for \
    atinit"zicompinit; zicdreplay" zdharma/fast-syntax-highlighting

zplugin ice wait"0" lucid
zplugin load zdharma/history-search-multi-word

#--------------------------------#
# history
#--------------------------------#
zinit wait'1' lucid \
    if"(( ${ZSH_VERSION%%.*} > 4.4))" \
        light-mode for @zsh-users/zsh-history-substring-search

#--------------------------------#
# fzf
#--------------------------------#
zinit wait'0b' lucid \
    from"gh-r" as"program" \
    for @junegunn/fzf

#--------------------------------#
# extension
#--------------------------------#
zinit wait'0' lucid \
    light-mode for @mafredri/zsh-async

#--------------------------------#
# enhanced command
#--------------------------------#

GEOMETRY_COLOR_DIR=152
zinit ice wait"0" lucid atload"geometry::prompt"
zinit light geometry-zsh/geometry

zinit wait'1' lucid blockf nocompletions \
    from"gh-r" as'program' pick'ripgrep*/rg' \
    atclone'chown -R $(id -nu):$(id -ng) .; zinit creinstall -q BurntSushi/ripgrep' \
    atpull'%atclone' \
    light-mode for @BurntSushi/ripgrep

zinit wait'1' lucid blockf nocompletions \
    from"gh-r" as'program' pick'fd*/fd' \
    atclone'chown -R $(id -nu):$(id -ng) .; zinit creinstall -q sharkdp/fd' \
    atpull'%atclone' \
    light-mode for @sharkdp/fd

zinit wait'1' lucid \
    from"gh-r" as"program" pick"rip*/rip" \
    atload"alias rm='rip --graveyard ~/.local/share/Trash'" \
    light-mode for @nivekuil/rip

zinit wait'1' lucid \
    from"gh-r" as"program" bpick'*lnx*' \
    light-mode for @dalance/procs

zinit wait'1' lucid \
    from"gh-r" as"program" pick"mmv*/mmv" \
    light-mode for @itchyny/mmv

#--------------------------------#
# program
#--------------------------------#

zinit wait'1' lucid \
    from"gh-r" as'program' bpick'*linux_*.tar.gz' pick'gh*/**/gh' \
    light-mode for @cli/cli


zinit wait'1' lucid \
    from"gh-r" as"program" mv"hub-*/bin/hub -> hub" pick"hub" \
    atload"alias git=hub" \
    for @github/hub
