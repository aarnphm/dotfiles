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


# PROMPT="%~"$'\n'"» "
zinit wait'!0b' lucid depth=1 \
  atload"source $ZRCDIR/configs/powerlevel10k_atload.zsh" \
  light-mode for @romkatv/powerlevel10k

#--------------------------------#
# completion
#--------------------------------#

zinit wait'0b' lucid as"completion" \
  atload"source $ZRCDIR/configs/zsh-completions_atload.zsh" \
  light-mode for @zsh-users/zsh-completions

zinit wait'0a' lucid \
  if"(( ${ZSH_VERSION%%.*} > 4.4))" \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
  light-mode for @zdharma/fast-syntax-highlighting

zplugin ice wait"0a" lucid \
  atinit"source $ZRCDIR/configs/zsh-autocomplete_atinit.zsh" \
  light-mode for @zdharma/history-search-multi-word

#--------------------------------#
# history
#--------------------------------#
zinit wait'1' lucid \
    if"(( ${ZSH_VERSION%%.*} > 4.4))" \
        light-mode for @zsh-users/zsh-history-substring-search

#--------------------------------#
# improve cd
#--------------------------------#
zinit wait'1' lucid \
  from"gh-r" as"program" pick"zoxide-*/zoxide" \
  atload"source $ZRCDIR/configs/zoxide_atload.zsh" \
  light-mode for @ajeetdsouza/zoxide

zinit wait'1' lucid \
  light-mode for @mollifier/cd-gitroot

zinit wait'1' lucid \
  light-mode for @peterhurford/up.zsh

zinit wait'1' lucid \
  light-mode for @Tarrasch/zsh-bd

#--------------------------------#
# fzf
#--------------------------------#
zinit wait'0b' lucid \
  from"gh-r" as"program" \
  atload"source $ZRCDIR/configs/fzf_atload.zsh" \
  for @junegunn/fzf
zinit ice wait'0a' lucid
zinit snippet https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh
zinit ice wait'1a' lucid atload"source $ZRCDIR/configs/fzf_completion_atload.zsh"
zinit snippet https://github.com/junegunn/fzf/blob/master/shell/completion.zsh
zinit ice wait'0a' lucid as"program"
zinit snippet https://github.com/junegunn/fzf/blob/master/bin/fzf-tmux


zinit wait'2' lucid blockf depth"1" \
  atclone'deno cache --no-check ./bin/zeno' \
  atpull'%atclone' \
  atinit"source $ZRCDIR/configs/zeno_atinit.zsh" \
  atload"source $ZRCDIR/configs/zeno_atload.zsh" \
  for @yuki-yano/zeno.zsh

#--------------------------------#
# extension
#--------------------------------#
zinit wait'0' lucid \
    light-mode for @mafredri/zsh-async

#--------------------------------#
# enhanced command
#--------------------------------#

zinit wait'1' lucid \
  from"gh-r" as"program" pick"bin/exa" \
  atload"source $ZRCDIR/configs/exa_atload.zsh" \
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
  from"gh-r" as"program" cp"bat/autocomplete/bat.zsh -> _bat" pick"bat*/bat" \
  atload"export BAT_THEME='1337';alias cat=bat" \
  light-mode for @sharkdp/bat

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
  from"gh-r" as"program" pick"ghq*/ghq" \
  atload"source $ZRCDIR/configs/ghq_atload.zsh" \
  light-mode for @x-motemen/ghq

zinit wait'1' lucid \
  from"gh-r" as"program" pick"ghg*/ghg" \
  light-mode for @Songmu/ghg

zinit wait'1' lucid \
  from"gh-r" as'program' bpick'*linux_*.tar.gz' pick'gh*/**/gh' \
  atload"source $ZRCDIR/configs/gh_atload.zsh" \
  light-mode for @cli/cli

zinit wait'1' lucid \
  from"gh-r" as"program" cp"hub-*/etc/hub.zsh_completion -> _hub" pick"hub-*/bin/hub" \
  atload"source $ZRCDIR/configs/hub_atload.zsh" \
  for @github/hub


#==============================================================#
# completion
#==============================================================#
zinit wait'2' lucid \
  atload"zicompinit; zicdreplay" \
  light-mode for "$ZRCDIR/plugins/auto_commands.zsh"
