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
ZHOMEDIR="${ZHOMEDIR:-$HOME/.config/zsh}"
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
# git
#--------------------------------#
zinit wait'2' lucid \
    light-mode for @caarlos0/zsh-git-sync

#--------------------------------#
# fzf
#--------------------------------#
zinit wait'0b' lucid \
    from"gh-r" as"program" \
    atload"source $ZHOMEDIR/rc/configs/fzf_atload.zsh" \
    for @junegunn/fzf
        zinit ice wait'0a' lucid
        zinit snippet https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh
        zinit ice wait'1a' lucid atload"source $ZHOMEDIR/rc/configs/fzf_completion.zsh_atload.zsh"
        zinit snippet https://github.com/junegunn/fzf/blob/master/shell/completion.zsh
        zinit ice wait'0a' lucid as"program"
        zinit snippet https://github.com/junegunn/fzf/blob/master/bin/fzf-tmux

        zinit wait'0c' lucid \
            pick"fzf-finder.plugin.zsh" \
            atinit"source $ZHOMEDIR/rc/configs/zsh-plugin-fzf-finder_atinit.zsh" \
            light-mode for @leophys/zsh-plugin-fzf-finder

        zinit wait'0c' lucid \
            atinit"source $ZHOMEDIR/rc/configs/fzf-mark_atinit.zsh" \
            light-mode for @urbainvaes/fzf-marks

        zinit wait'2' lucid \
            atinit"source $ZHOMEDIR/rc/configs/zsh-fzf-widgets_atinit.zsh" \
            light-mode for @amaya382/zsh-fzf-widgets

# after load fzf-zsh-completions
zinit wait'1' lucid \
    atinit"FZF_PREVIEW_DISABLE_DEFAULT_BINDKEY=1" \
    atload"source $ZHOMEDIR/rc/configs/fzf-preview_atload.zsh" \
    light-mode for @yuki-ycino/fzf-preview.zsh

#--------------------------------#
# extension
#--------------------------------#
zinit wait'0' lucid \
    light-mode for @mafredri/zsh-async

#--------------------------------#
# enhanced command
#--------------------------------#
zinit wait'1' lucid \
    from"gh-r" as"program" mv"exa* -> exa" \
    atload"alias ls=exa" \
    light-mode for @ogham/exa

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
    from"gh-r" as"program" pick"tldr" \
    light-mode for @dbrgn/tealdeer
zinit ice wait'1' lucid as"completion" mv'zsh_tealdeer -> _tldr'
zinit snippet https://github.com/dbrgn/tealdeer/blob/master/zsh_tealdeer

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
    atload"source $ZHOMEDIR/rc/configs/gh_atload.zsh" \
    light-mode for @cli/cli

# env #
zinit wait'1' lucid \
    from"gh-r" as"program" mv"direnv* -> direnv" pick"direnv" \
    atclone'./direnv hook zsh > zhook.zsh' \
    atpull'%atclone' \
    light-mode for @direnv/direnv

zinit wait'1' lucid \
    from"gh-r" as"program" mv"hub-*/bin/hub -> hub" pick"hub" \
    atload"source $ZHOMEDIR/rc/configs/hub_atload.zsh" \
    for @github/hub

#==============================================================#
# Analytics
#==============================================================#
if [[ "${DISABLE_WAKATIME}" == "true" ]]; then
    zinit wait'2' lucid \
        atpull'pip install wakatime' \
        light-mode for @sobolevn/wakatime-zsh-plugin
fi

#==============================================================#
# local plugins
#==============================================================#
[ -f "$HOME/.zshrc.plugin.local" ] && source "$HOME/.zshrc.plugin.local"
