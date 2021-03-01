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
  git clone --depth 10 https://github.com/zdharma/zinit.git ${ZPLG_HOME}/bin
fi

typeset -gAH ZPLGM
ZPLGM[HOME_DIR]="${ZPLG_HOME}"
source "$HOME/.zinit/bin/zinit.zsh"
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
zinit wait'1' lucid \
  atload"source $ZHOMEDIR/rc/configs/emoji-cli_atload.zsh" \
  light-mode for @b4b4r07/emoji-cli

zinit wait'0' lucid \
  light-mode for @mafredri/zsh-async

#--------------------------------#
# enhancive command
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
  from"gh-r" as"program" pick"delta*/delta" \
  light-mode for @dandavison/delta

zinit wait'1' lucid \
  from"gh-r" as"program" pick"mmv*/mmv" \
  light-mode for @itchyny/mmv


#--------------------------------#
# program
#--------------------------------#
# zsh
if [[ "${ZSH_INSTALL}" == "true" ]]; then
  # zinit pack for zsh
  if builtin command -v make > /dev/null 2>&1; then
      zinit id-as=zsh as"null" lucid depth=1 \
        atclone"./.preconfig; m {hi}Building Zsh...{rst}; \
          CPPFLAGS='-I/usr/include -I/usr/local/include' CFLAGS='-g -O2 -Wall' LDFLAGS='-L/usr/libs -L/usr/local/libs' \
          ./configure --prefix=\"$ZPFX\" \
            --enable-multibyte \
            --enable-function-subdirs \
            --with-tcsetpgrp \
            --enable-pcre \
            --enable-cap \
            --enable-zsh-secure-free \
            >/dev/null && \
          { type yodl &>/dev/null || \
            { m -u2 {warn}WARNING{ehi}:{rst}{warn} No {cmd}yodl{warn}, manual pages will not be built.{rst}; ((0)); } && \
            { make install; ((1)); } || make install.bin install.fns install.modules } >/dev/null && \
          { type sudo &>/dev/null && sudo rm -f /bin/zsh && sudo cp -vf Src/zsh /bin/zsh; ((1)); } && \
            m {success}The build succeeded.{rst} || m {failure}The build failed.{rst}" \
        atpull"%atclone" nocompile countdown git \
        for @zsh-users/zsh
  fi
fi

# git
if builtin command -v make > /dev/null 2>&1; then
  zinit wait'0' lucid nocompile \
    id-as=git as='null|readurl' \
    mv"%ID% -> git.tar.gz" \
    atclone'ziextract --move --auto git.tar.gz && \
      make -j $[$(grep cpu.cores /proc/cpuinfo | sort -u | sed "s/[^0-9]//g") + 1] prefix=$ZPFX all install && \
      \rm -rf $ZINIT[SNIPPETS_DIR]/git/*' \
    atpull"%atclone" \
    dlink='/git/git/archive/v%VERSION%.tar.gz' \
    for https://github.com/git/git/releases/
fi

# neovim
zinit wait'0' lucid \
  from'gh-r' ver'nightly' as'program' pick'nvim*/bin/nvim' \
  atclone'echo "" > ._zinit/is_release' \
  atpull'%atclone' \
  run-atpull \
  light-mode for @neovim/neovim

# node (for coc.nvim)
zinit wait'0' lucid id-as=node as='readurl|command' \
  nocompletions extract \
  pick'node*/bin/*' \
  dlink='node-v%VERSION%-linux-x64.tar.gz' \
  for https://nodejs.org/download/release/latest/

# tmux
if ldconfig -p | grep -q 'libevent-' && ldconfig -p | grep -q 'libncurses'; then
  zinit wait'0' lucid \
    from"gh-r" as"program" bpick"tmux-*.tar.gz" pick"*/tmux" \
    atclone"cd tmux*/; ./configure; make" \
    atpull"%atclone" \
    light-mode for @tmux/tmux
elif builtin command -v tmux > /dev/null 2>&1 && test $(echo "$(tmux -V | cut -d' ' -f2) <= "2.5"" | tr -d '[:alpha:]' | bc) -eq 1; then
  zinit wait'0' lucid \
    from'gh-r' as'program' bpick'*AppImage*' mv'tmux* -> tmux' pick'tmux' \
    light-mode for @tmux/tmux
fi

# translation #
zinit wait'1' lucid \
  light-mode for @soimort/translate-shell

zinit wait'1' lucid \
  atclone"python setup.py install --prefix=${ZPLG_HOME}/polaris/" \
  atpull'%atclone' \
  light-mode for @nidhaloff/deep-translator

zinit wait'1' lucid \
  from"gh-r" as"program" \
  atload"source $ZHOMEDIR/rc/configs/nextword_atload.zsh" \
  light-mode for @high-moctane/nextword

# env #
zinit wait'1' lucid \
  from"gh-r" as"program" mv"direnv* -> direnv" pick"direnv" \
  atclone'./direnv hook zsh > zhook.zsh' \
  atpull'%atclone' \
  light-mode for @direnv/direnv

zinit wait'1' lucid \
  pick"asdf.sh" \
  light-mode for @asdf-vm/asdf

# GitHub #
zinit wait'1' lucid \
  from"gh-r" as"program" pick"ghq*/ghq" \
  atload"source $ZHOMEDIR/rc/configs/ghq_atload.zsh" \
  light-mode for @x-motemen/ghq

zinit wait'1' lucid \
  from"gh-r" as"program" pick"ghg*/ghg" \
  light-mode for @Songmu/ghg

zinit wait'1' lucid \
  from"gh-r" as'program' bpick'*linux_*.tar.gz' pick'gh*/**/gh' \
  atload"source $ZHOMEDIR/rc/configs/gh_atload.zsh" \
  light-mode for @cli/cli

zinit wait'1' lucid \
  from"gh-r" as"program" mv"hub-*/bin/hub -> hub" pick"hub" \
  atload"source $ZHOMEDIR/rc/configs/hub_atload.zsh" \
  for @github/hub

# snippet
[[ $- == *i* ]] && stty -ixon
zinit wait'1' lucid blockf nocompletions \
  from"gh-r" as"program" pick"pet" bpick'*linux_amd64.tar.gz' \
  atclone'chown -R $(id -nu):$(id -ng) .; zinit creinstall -q knqyf263/pet' \
  atpull'%atclone' \
  atload"source $ZHOMEDIR/rc/configs/pet_atload.zsh" \
  for @knqyf263/pet

# etc #
zinit wait'1' lucid \
  as"program" pick"emojify" \
  light-mode for @mrowa44/emojify


#==============================================================#
# my plugins
#==============================================================#
zinit wait'1' lucid \
  atload"source $ZHOMEDIR/rc/configs/mru.zsh_atload.zsh" \
  light-mode for "$ZHOMEDIR/rc/cplugins/mru.zsh/"


#==============================================================#
# Analytics
#==============================================================#
if [[ "${DISABLE_WAKATIME}" == "true" ]]; then
  zinit wait'2' lucid \
    atpull'pip install wakatime' \
    light-mode for @sobolevn/wakatime-zsh-plugin
fi


#==============================================================#
# completion
#==============================================================#
zinit wait'2' lucid \
  light-mode for "$ZHOMEDIR/rc/cplugins/command_config.zsh"

#==============================================================#
# local plugins
#==============================================================#
[ -f "$HOME/.zshrc.plugin.local" ] && source "$HOME/.zshrc.plugin.local"
