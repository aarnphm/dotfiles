#!/usr/bin/env bash
# Make vim the default editor.
export EDITOR='/usr/bin/vim';
export VISUAL='nvim';
export BROWSER=/usr/bin/firefox
export DISPLAY=:0

# export python
export PYENV_ROOT="$HOME/.pyenv";
export PYENV_SHELL=zsh
export PYTHONPATH="$HOME/.local/lib/python3.8/site-packages:/usr/lib/python3.8/site-packages"
export QT_QPA_PLATFORMTHEME=qt5ct

# fzf 
export FZF_DEFAULT_OPTS="--layout=reverse
--info=inline
--height=80%
--multi
--preview-window=:hidden
--preview '([[ -f {} ]] && (bat --style=numbers {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
--prompt='∼ ' --pointer='>' --marker='✓'
--bind '?:toggle-preview'
--bind 'ctrl-a:select-all'
--bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'
--bind 'ctrl-e:execute(echo {+} | xargs -o vim)'
--bind 'ctrl-v:execute(code {+})'";

# wine prefix
export WINEPREFIX="$HOME/.wine32" 
export WINEARCH=win32
# XDG  config
export XDG_CONFIG_DIRS="/etc/xdg"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_DOCUMENTS="$HOME/Documents"
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
export QT_QPA_PLATFORMTHEME="qt5ct"

# npm config
export NPM_PACKAGES="${HOME}/.npm-packages"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"

# defined go path
export GOPATH="$HOME/go"
export GOPROXY="https://proxy.golang.org/,direct"

# define Gem path
export GEMPATH="$HOME/.gem/ruby/2.7.0"

# define java path
if [[ "$OSTYPE" == "darwin"* ]]; then
		export JAVA_HOME="/usr/local/opt/openjdk/libexec/openjdk.jdk/Contents/Home"
fi
# define PATH
export PATH="/home/aarnphm/.pyenv/shims:$JAVA_HOME/bin:${PATH}:$HOME/google-cloud-sdk/bin:$HOME/.poetry/bin:$GEMPATH/bin:$NPM_PACKAGES/bin:$GOPATH/bin:$GOPATH/src:$HOME/spicetify-cli/:$PYENV_ROOT/bin:$HOME/.local/bin:$HOME/.cargo/bin"
export PATH=`printf %s "$PATH" | awk -v RS=: '{ if (!arr[$0]++) {printf("%s%s",!ln++?"":":",$0)}}'`

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
export PYTHONIOENCODING='UTF-8';
export PYTHONDONTWRITEBYTECODE=1
# Increase Bash history size. Allow 32³ entries; the default is 500.
export HISTFILE=~/.histfile
export HISTSIZE='32768';
export HISTFILESIZE="${HISTSIZE}";
# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL='ignoreboth';

# Prefer CA English and use UTF-8.
export LANGUAGE='en';
export HOST='0x6161726E70';

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}";

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X';

export LD_LIBRARY_PATH="/usr/local/lib"
# Avoid issues with `gpg` as installed via Homebrew.
# https://stackoverflow.com/a/42265848/96656
export GPG_TTY=$(tty);

# Hide the “default interactive shell is now zsh” warning on macOS.
export BASH_SILENCE_DEPRECATION_WARNING=1;

#nnn
export NNN_BMS='u:~/Documents;D:~/Downloads/'
export NNN_SSHFS="sshfs -o follow_symlinks"        # make sshfs follow symlinks on the remote
export NNN_COLORS="2134"                           # use a different color for each context
export NNN_TRASH=1                                 # trash (needs trash-cli) instead of delete
export NNN_PLUG='f:finder;o:fzopen;p:mocplay;d:diffs;t:nmount;v:imgview'
export NNN_FIFO=/tmp/nnn.fifo

# FZF
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS='--preview="cat {}" --preview-window=right:60%:wrap'
export FZF_ALT_C_OPTS='--preview="ls {}" --preview-window=right:60%:wrap'
export LS_COLORS="${LS_COLORS}:ow=01;33"
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
