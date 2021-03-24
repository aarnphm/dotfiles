# Simple - aarnphm
# For my own and others sanity
# git:
# %b => current branch
# %a => current action (rebase/merge)
# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)
# terminal codes:
# \e7   => save cursor position
# \e[2A => move cursor 2 lines up
# \e[1G => go to position 1 in terminal
# \e8   => restore cursor position
# \e[K  => clears everything after the cursor on the current line
# \e[2K => clear everything on the current line

# separate async_git task
scripts_dir="${ZRCDIR:-$XDG_CONFIG_HOME/zsh/rc}/simple"
source $scripts_dir/async_git.zsh

#==============================================================#
##         Drawing logics                                     ##
#==============================================================#
# Turns seconds into human readable time.
# 165392 => 1d 21h 56m 32s
# https://github.com/sindresorhus/pretty-time-zsh
prompt_simple_human_time_to_var() {
  local human total_seconds=$1 var=$2
  local days=$(( total_seconds / 60 / 60 / 24 ))
  local hours=$(( total_seconds / 60 / 60 % 24 ))
  local minutes=$(( total_seconds / 60 % 60 ))
  local seconds=$(( total_seconds % 60 ))
  (( days > 0 )) && human+="${days}d "
  (( hours > 0 )) && human+="${hours}h "
  (( minutes > 0 )) && human+="${minutes}m "
  human+="${seconds}s"

    # Store human readable time in a variable as specified by the caller
    typeset -g "${var}"="${human}"
  }

prompt_simple_set_title() {
  setopt localoptions noshwordsplit

  # Emacs terminal does not support settings the title.
    (( ${+EMACS} || ${+INSIDE_EMACS} )) && return

    case $TTY in
      # Don't set title over serial console.
      /dev/ttyS[0-9]*) return;;
    esac

    # Show hostname if connected via SSH.
    local hostname=
    if [[ -n $prompt_simple_state[username] ]]; then
      # Expand in-place in case ignore-escape is used.
      hostname="${(%):-(%m) }"
    fi

    local -a opts
    case $1 in
      expand-prompt) opts=(-P);;
      ignore-escape) opts=(-r);;
    esac

    # Set title atomically in one print statement so that it works when XTRACE is enabled.
    print -n $opts $'\e]0;'${hostname}${2}$'\a'
  }

# Stores (into prompt_simple_cmd_exec_time) the execution
# time of the last command if set threshold was exceeded.
# This will shows execution time regardless, turn it off
# with SIMPLE_CMD_MAX_EXEC_TIME
prompt_simple_check_cmd_exec_time() {
  integer elapsed
  (( elapsed = EPOCHSECONDS - ${prompt_simple_cmd_timestamp:-$EPOCHSECONDS} ))
  typeset -g prompt_simple_cmd_exec_time=
  (( elapsed > ${SIMPLE_CMD_MAX_EXEC_TIME:-0} )) && {
    prompt_simple_human_time_to_var $elapsed "prompt_simple_cmd_exec_time"
  }
}

prompt_simple_preexec() {
  if [[ -n $prompt_simple_git_fetch_pattern ]]; then
    # Detect when Git is performing pull/fetch, including Git aliases.
    local -H MATCH MBEGIN MEND match mbegin mend
    if [[ $2 =~ (git|hub)\ (.*\ )?($prompt_simple_git_fetch_pattern)(\ .*)?$ ]]; then
      # We must flush the async jobs to cancel our git fetch in order
      # to avoid conflicts with the user issued pull / fetch.
      async_flush_jobs 'prompt_simple'
    fi
  fi

  typeset -g prompt_simple_cmd_timestamp=$EPOCHSECONDS

    # Shows the current directory and executed command in the title while a process is active.
    prompt_simple_set_title 'ignore-escape' "$PWD:t: $2"

    # Disallow Python virtualenv from updating the prompt. Set it to 12 if
    # untouched by the user to indicate that simple modified it. Here we use
    # the magic number 12, same as in `psvar`.
    export VIRTUAL_ENV_DISABLE_PROMPT=${VIRTUAL_ENV_DISABLE_PROMPT:-12}
  }

# Change the colors if their value are different from the current ones.
prompt_simple_set_colors() {
  local color_temp key value
  for key value in ${(kv)prompt_simple_colors}; do
    zstyle -t ":prompt:simple:$key" color "$value"
    case $? in
      1) # The current style is different from the one from zstyle.
        zstyle -s ":prompt:simple:$key" color color_temp
        prompt_simple_colors[$key]=$color_temp ;;
      2) # No style is defined.
        prompt_simple_colors[$key]=$prompt_simple_colors_default[$key] ;;
    esac
  done
}

prompt_simple_reset_prompt() {
  if [[ $CONTEXT == cont ]]; then
    # When the context is "cont", PS2 is active and calling
    # reset-prompt will have no effect on PS1, but it will
    # reset the execution context (%_) of PS2 which we don\'t
    # want. Unfortunately, we can\'t save the output of "%_"
    # either because it is only ever rendered as part of the
    # prompt, expanding in-place won\'t work.
    return
  fi

  zle && zle .reset-prompt
}

prompt_simple_reset_prompt_symbol() {
  prompt_simple_state[prompt]=${SIMPLE_PROMPT_SYMBOL:-➜}
}

prompt_simple_update_vim_prompt_widget() {
  setopt localoptions noshwordsplit
  prompt_simple_state[prompt]=${${KEYMAP/vicmd/${SIMPLE_PROMPT_VICMD_SYMBOL:-[vi]}}/(main|viins)/${SIMPLE_PROMPT_SYMBOL:-➜}}

  prompt_simple_reset_prompt
}

prompt_simple_reset_vim_prompt_widget() {
  setopt localoptions noshwordsplit
  prompt_simple_reset_prompt_symbol
}

prompt_simple_precmd() {
  setopt localoptions noshwordsplit

    # Check execution time and store it in a variable.
    prompt_simple_check_cmd_exec_time
    unset prompt_simple_cmd_timestamp

    # Shows the full path in the title.
    prompt_simple_set_title 'expand-prompt' '%~'

    # Modify the colors if some have changed..
    prompt_simple_set_colors

    # Perform async Git dirty check and fetch.
    prompt_simple_async_tasks

    # Check if we should display the virtual env. We use a sufficiently high
    # index of psvar (12) here to avoid collisions with user defined entries.
    psvar[12]=
    # Check if a Conda environment is active and display its name.
    if [[ -n $CONDA_DEFAULT_ENV ]]; then
      psvar[12]="${CONDA_DEFAULT_ENV//[$'\t\r\n']}"
    fi
    # When VIRTUAL_ENV_DISABLE_PROMPT is empty, it was unset by the user and
    # simple should take back control.
    if [[ -n $VIRTUAL_ENV ]] && [[ -z $VIRTUAL_ENV_DISABLE_PROMPT || $VIRTUAL_ENV_DISABLE_PROMPT = 12 ]]; then
      psvar[12]="${VIRTUAL_ENV:t}"
      export VIRTUAL_ENV_DISABLE_PROMPT=12
    fi

    # Make sure VIM prompt is reset.
    prompt_simple_reset_prompt_symbol

    # Render prompt
    prompt_simple_reset_prompt
    prompt_simple_prerender

    if [[ -n $ZSH_THEME ]]; then
      print "WARNING: Oh My Zsh themes are enabled (ZSH_THEME='${ZSH_THEME}'). simple might not be working correctly."
      print "For more information, see: https://github.com/sindresorhus/simple#oh-my-zsh"
      unset ZSH_THEME  # Only show this warning once.
    fi
  }

prompt_simple_prerender() {
  setopt localoptions noshwordsplit
  unset prompt_simple_async_render_requested

    # Setup prompt here, instead of preprompt
    local -a prompt_parts
    local -a rprompt_parts
    local -a git_parts

    # TODO: better accent handling
    [[ -n $prompt_simple_state[username] ]] && prompt_parts+=($prompt_simple_state[username]$prompt_simple_state[accent])
    # path
    prompt_parts+=('%F{${prompt_simple_colors[path]}}%c%f${prompt_simple_state[accent]}%f')

    # Set color for Git branch/dirty status and change color if dirty checking has been delayed.
    local git_color=$prompt_simple_colors[git:branch]
    local git_dirty_color=$prompt_simple_colors[git:dirty]
    [[ -n ${prompt_simple_git_last_dirty_check_timestamp+x} ]] && git_color=$prompt_simple_colors[git:branch:cached]

    # Git branch and dirty status info.
    typeset -gA prompt_simple_vcs_info
    if [[ -n $prompt_simple_vcs_info[branch] ]]; then
      git_parts+=("%F{$git_color}"'${prompt_simple_vcs_info[branch]}'"%F{$git_dirty_color}"'${prompt_simple_git_dirty}%f')
    fi
    # Git action (for example, merge).
    if [[ -n $prompt_simple_vcs_info[action] ]]; then
      git_parts+=("%F{$prompt_simple_colors[git:action]}"'$prompt_simple_vcs_info[action]%f')
    fi
    # Git pull/push arrows.
    if [[ -n $prompt_simple_git_arrows ]]; then
      git_parts+=('%F{$prompt_simple_colors[git:arrow]}${prompt_simple_git_arrows}%f')
    fi
    # Git stash symbol (if opted in).
    if [[ -n $prompt_simple_git_stash ]]; then
      git_parts+=('%F{$prompt_simple_colors[git:stash]}${SIMPLE_GIT_STASH_SYMBOL:-≡}%f')
    fi

    [[ -n $prompt_simple_cmd_exec_time ]] && rprompt_parts+=('[%F{$prompt_simple_colors[execution_time]}${prompt_simple_cmd_exec_time}%f]')

    local cleaned_ps1=$PROMPT
    local -H MATCH MBEGIN MEND
    if [[ $PROMPT = *$prompt_newline* ]]; then
      # Remove everything from the prompt until the newline. This
      # removes the preprompt and only the original PROMPT remains.
      cleaned_ps1=${PROMPT##*${prompt_newline}}
    fi
    unset MATCH MBEGIN MEND

    # Contruct new prompt after cleaning
    local -ah ps1
    local -ah rps1
    ps1=(${(j..)prompt_parts})
    rps1=(${(j..)git_parts} ${(j..)rprompt_parts})

    PROMPT="${(j..)ps1}"
    RPROMPT="${(j. .)rps1}"

    # Prompt turns red if the previous command didn\'t exit with 0.
    local prompt_indicator=' %(?.%F{$prompt_simple_colors[prompt:success]}.%F{$prompt_simple_colors[prompt:error]})${prompt_simple_state[prompt]}%f '
    PROMPT+=$prompt_indicator
  }

prompt_simple_state_setup() {
  setopt localoptions noshwordsplit

    # Check SSH_CONNECTION and the current state.
    local ssh_connection=${SSH_CONNECTION:-$PROMPT_SIMPLE_SSH_CONNECTION}
    local username hostname
    if [[ -z $ssh_connection ]] && (( $+commands[who] )); then
      # When changing user on a remote system, the $SSH_CONNECTION
      # environment variable can be lost. Attempt detection via `who`.
      local who_out
      who_out=$(who -m 2>/dev/null)
      if (( $? )); then
        # Who am I not supported, fallback to plain who.
        local -a who_in
        who_in=( ${(f)"$(who 2>/dev/null)"} )
        who_out="${(M)who_in:#*[[:space:]]${TTY#/dev/}[[:space:]]*}"
      fi

      local reIPv6='(([0-9a-fA-F]+:)|:){2,}[0-9a-fA-F]+'  # Simplified, only checks partial pattern.
      local reIPv4='([0-9]{1,3}\.){3}[0-9]+'   # Simplified, allows invalid ranges.
      # Here we assume two non-consecutive periods represents a
      # hostname. This matches `foo.bar.baz`, but not `foo.bar`.
      local reHostname='([.][^. ]+){2}'

        # Usually the remote address is surrounded by parenthesis, but
        # not on all systems (e.g. busybox).
        local -H MATCH MBEGIN MEND
        if [[ $who_out =~ "\(?($reIPv4|$reIPv6|$reHostname)\)?\$" ]]; then
          ssh_connection=$MATCH

            # Export variable to allow detection propagation inside
            # shells spawned by this one (e.g. tmux does not always
            # inherit the same tty, which breaks detection).
            export PROMPT_SIMPLE_SSH_CONNECTION=$ssh_connection
        fi
        unset MATCH MBEGIN MEND
    fi

    hostname='%F{$prompt_simple_colors[host]}@%m%f'
    # setup a default username
    username='%F{$prompt_simple_colors[user]}%n%f'
    # Show `username@host` if logged in through SSH.
    [[ -n $ssh_connection ]] && username='%F{$prompt_simple_colors[user]}%n%f'"$hostname"

    # Show `username@host` if inside a container.
    prompt_simple_is_inside_container && username='%F{$prompt_simple_colors[user]}%n%f'"$hostname"

    # Show `username@host` if root, with username in default color.
    [[ $UID -eq 0 ]] && username='%F{$prompt_simple_colors[user:root]}%n%f'"$hostname"

    typeset -gA prompt_simple_state
    prompt_simple_state+=(
    username "$username"
    accent   "${SIMPLE_PROMPT_ACCENT:-::}"
    prompt   "${SIMPLE_PROMPT_SYMBOL:-➜}")

  }

# Return true if executing inside a Docker or LXC container.
prompt_simple_is_inside_container() {
  local -r cgroup_file='/proc/1/cgroup'
  [[ -r "$cgroup_file" && "$(< $cgroup_file)" = *(lxc|docker)* ]] \
    || [[ "$container" == "lxc" ]]
  }

prompt_simple_setup() {

    # Prevent percentage showing up if output doesn\'t end with a newline.
    export PROMPT_EOL_MARK=''

    prompt_opts=(subst percent)

    # Borrowed from `promptinit`. Sets the prompt options in case simple was not
    # initialized via `promptinit`.
    setopt noprompt{bang,cr,percent,subst} "prompt${^prompt_opts[@]}"

    if [[ -z $prompt_newline ]]; then
      # This variable needs to be set, usually set by promptinit.
      typeset -g prompt_newline=$'\n%{\r%}'
    fi

    zmodload zsh/datetime
    zmodload zsh/zle
    zmodload zsh/parameter
    zmodload zsh/zutil

    autoload -Uz add-zsh-hook
    autoload -Uz vcs_info
    autoload -Uz async && async

    # The `add-zle-hook-widget` function is not guaranteed to be available.
    # It was added in Zsh 5.3.
    autoload -Uz +X add-zle-hook-widget 2>/dev/null

    # Set the colors.
    typeset -gA prompt_simple_colors_default prompt_simple_colors
    prompt_simple_colors_default=(
      execution_time       yellow
      git:arrow            cyan
      git:stash            cyan
      git:branch           242
      git:branch:cached    red
      git:action           yellow
      git:dirty            218
      host                 242
      path                 blue
      prompt:error         red
      prompt:success       magenta
      prompt:continuation  242
      user                 242
      user:root            default
      virtualenv           242
    )
    prompt_simple_colors=("${(@kv)prompt_simple_colors_default}")

    add-zsh-hook precmd prompt_simple_precmd

    add-zsh-hook preexec prompt_simple_preexec

    # setup users and SSH
    prompt_simple_state_setup

    zle -N prompt_simple_reset_prompt
    zle -N prompt_simple_update_vim_prompt_widget
    zle -N prompt_simple_reset_vim_prompt_widget
    if (( $+functions[add-zle-hook-widget] )); then
      add-zle-hook-widget zle-line-finish prompt_simple_reset_vim_prompt_widget
      add-zle-hook-widget zle-keymap-select prompt_simple_update_vim_prompt_widget
    fi

    # Indicate continuation prompt by … and use a darker color for it.
    PROMPT2='%F{$prompt_simple_colors[prompt:continuation]}… %(1_.%_ .%_)%f'$prompt_indicator

    # Store prompt expansion symbols for in-place expansion via (%). For
    # some reason it does not work without storing them in a variable first.
    typeset -ga prompt_simple_debug_depth
    prompt_simple_debug_depth=('%e' '%N' '%x')

    # Compare is used to check if %N equals %x. When they differ, the main
    # prompt is used to allow displaying both filename and function. When
    # they match, we use the secondary prompt to avoid displaying duplicate
    # information.
    local -A ps4_parts
    ps4_parts=(
      depth 	  '%F{yellow}${(l:${(%)prompt_simple_debug_depth[1]}::+:)}%f'
      compare   '${${(%)prompt_simple_debug_depth[2]}:#${(%)prompt_simple_debug_depth[3]}}'
      main      '%F{blue}${${(%)prompt_simple_debug_depth[3]}:t}%f%F{242}:%I%f %F{242}@%f%F{blue}%N%f%F{242}:%i%f'
      secondary '%F{blue}%N%f%F{242}:%i'
      prompt 	  '%F{242}>%f '
    )
    # Combine the parts with conditional logic. First the `:+` operator is
    # used to replace `compare` either with `main` or an ampty string. Then
    # the `:-` operator is used so that if `compare` becomes an empty
    # string, it is replaced with `secondary`.
    local ps4_symbols='${${'${ps4_parts[compare]}':+"'${ps4_parts[main]}'"}:-"'${ps4_parts[secondary]}'"}'

    # Improve the debug prompt (PS4), show depth by repeating the +-sign and
    # add colors to highlight essential parts like file and function name.
    PROMPT4="${ps4_parts[depth]} ${ps4_symbols}${ps4_parts[prompt]}"

    # Guard against Oh My Zsh themes overriding simple.
    unset ZSH_THEME

    # Guard against (ana)conda changing the PS1 prompt
    # (we manually insert the env when it\'s available).
    export CONDA_CHANGEPS1=no
  }

prompt_simple_setup "$@"
# vim: set ft=zsh sw=2 et :
