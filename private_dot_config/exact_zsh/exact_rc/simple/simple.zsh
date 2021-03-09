#==============================================================#
##          simple                                            ##
#==============================================================#

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

#==============================================================#
##          Handles Git logics                                ##
#==============================================================#

prompt_simple_async_git_aliases() {
    setopt localoptions noshwordsplit
    local -a gitalias pullalias

    # List all aliases and split on newline.
    gitalias=(${(@f)"$(command git config --get-regexp "^alias\.")"})
    for line in $gitalias; do
        parts=(${(@)=line})           # Split line on spaces.
            aliasname=${parts[1]#alias.}  # Grab the name (alias.[name]).
            shift parts                   # Remove `aliasname`

        # Check alias for pull or fetch. Must be exact match.
        if [[ $parts =~ ^(.*\ )?(pull|fetch)(\ .*)?$ ]]; then
            pullalias+=($aliasname)
        fi
    done

    print -- ${(j:|:)pullalias}  # Join on pipe, for use in regex.
}

prompt_simple_async_vcs_info() {
    setopt localoptions noshwordsplit

    # Configure `vcs_info` inside an async task. This frees up `vcs_info`
    # to be used or configured as the user pleases.
    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' use-simple true
    # Only export four message variables from `vcs_info`.
    zstyle ':vcs_info:*' max-exports 3
    # Export branch (%b), Git toplevel (%R), action (rebase/cherry-pick) (%a)
    zstyle ':vcs_info:git*' formats '%b' '%R' '%a'
    zstyle ':vcs_info:git*' actionformats '%b' '%R' '%a'

    vcs_info

    local -A info
    info[pwd]=$PWD
    info[branch]=$vcs_info_msg_0_
    info[top]=$vcs_info_msg_1_
    info[action]=$vcs_info_msg_2_

    print -r - ${(@kvq)info}
}

# Fastest possible way to check if a Git repo is dirty.
prompt_simple_async_git_dirty() {
    setopt localoptions noshwordsplit
    local untracked_dirty=$1
    local untracked_git_mode=$(command git config --get status.showUntrackedFiles)
    if [[ "$untracked_git_mode" != 'no' ]]; then
        untracked_git_mode='normal'
    fi

    if [[ $untracked_dirty = 0 ]]; then
        command git diff --no-ext-diff --quiet --exit-code
    else
        test -z "$(GIT_OPTIONAL_LOCKS=0 command git status --porcelain --ignore-submodules -u${untracked_git_mode})"
    fi

    return $?
}

prompt_simple_async_git_fetch() {
    setopt localoptions noshwordsplit

    local only_upstream=${1:-0}

    # Sets `GIT_TERMINAL_PROMPT=0` to disable authentication prompt for Git fetch (Git 2.3+).
    export GIT_TERMINAL_PROMPT=0
    # Set SSH `BachMode` to disable all interactive SSH password prompting.
    export GIT_SSH_COMMAND="${GIT_SSH_COMMAND:-"ssh"} -o BatchMode=yes"

    local -a remote
    if ((only_upstream)); then
        local ref
        ref=$(command git symbolic-ref -q HEAD)
        # Set remote to only fetch information for the current branch.
        remote=($(command git for-each-ref --format='%(upstream:remotename) %(refname)' $ref))
        if [[ -z $remote[1] ]]; then
            # No remote specified for this branch, skip fetch.
            return 97
        fi
    fi

    # Default return code, which indicates Git fetch failure.
    local fail_code=99

    # Guard against all forms of password prompts. By setting the shell into
    # MONITOR mode we can notice when a child process prompts for user input
    # because it will be suspended. Since we are inside an async worker, we
    # have no way of transmitting the password and the only option is to
    # kill it. If we don't do it this way, the process will corrupt with the
    # async worker.
    setopt localtraps monitor

    # Make sure local HUP trap is unset to allow for signal propagation when
    # the async worker is flushed.
    trap - HUP

    trap '
    # Unset trap to prevent infinite loop
    trap - CHLD
    if [[ $jobstates = suspended* ]]; then
        # Set fail code to password prompt and kill the fetch.
        fail_code=98
        kill %%
    fi
    ' CHLD

    # Do git fetch and avoid fetching tags or
    # submodules to speed up the process.
    command git -c gc.auto=0 fetch \
        --quiet \
        --no-tags \
        --recurse-submodules=no \
        $remote &>/dev/null &
            wait $! || return $fail_code

            unsetopt monitor

    # Check arrow status after a successful `git fetch`.
    prompt_simple_async_git_arrows
}

prompt_simple_async_git_arrows() {
    setopt localoptions noshwordsplit
    command git rev-list --left-right --count HEAD...@'{u}'
}

# Try to lower the priority of the worker so that disk heavy operations
# like `git status` has less impact on the system responsivity.
prompt_simple_async_renice() {
    setopt localoptions noshwordsplit

    if command -v renice >/dev/null; then
        command renice +15 -p $$
    fi

    if command -v ionice >/dev/null; then
        command ionice -c 3 -p $$
    fi
}

prompt_simple_async_init() {
    typeset -g prompt_simple_async_inited
    if ((${prompt_simple_async_inited:-0})); then
        return
    fi
    prompt_simple_async_inited=1
    async_start_worker "prompt_simple" -u -n
    async_register_callback "prompt_simple" prompt_simple_async_callback
    async_worker_eval "prompt_simple" prompt_simple_async_renice
}

prompt_simple_async_tasks() {
    setopt localoptions noshwordsplit

    # Initialize the async worker.
    prompt_simple_async_init

    # Update the current working directory of the async worker.
    async_worker_eval "prompt_simple" builtin cd -q $PWD

    typeset -gA prompt_simple_vcs_info

    local -H MATCH MBEGIN MEND
    if [[ $PWD != ${prompt_simple_vcs_info[pwd]}* ]]; then
        # Stop any running async jobs.
        async_flush_jobs "prompt_simple"

        # Reset Git preprompt variables, switching working tree.
        unset prompt_simple_git_dirty
        unset prompt_simple_git_last_dirty_check_timestamp
        unset prompt_simple_git_arrows
        unset prompt_simple_git_fetch_pattern
        prompt_simple_vcs_info[branch]=
        prompt_simple_vcs_info[top]=
    fi
    unset MATCH MBEGIN MEND

    async_job "prompt_simple" prompt_simple_async_vcs_info

    # Only perform tasks inside a Git working tree.
    [[ -n $prompt_simple_vcs_info[top] ]] || return

    prompt_simple_async_refresh
}

prompt_simple_async_refresh() {
    setopt localoptions noshwordsplit

    if [[ -z $prompt_simple_git_fetch_pattern ]]; then
        # We set the pattern here to avoid redoing the pattern check until the
        # working tree has changed. Pull and fetch are always valid patterns.
        typeset -g prompt_simple_git_fetch_pattern="pull|fetch"
        async_job "prompt_simple" prompt_simple_async_git_aliases
    fi

    async_job "prompt_simple" prompt_simple_async_git_arrows

    # Do not perform `git fetch` if it is disabled or in home folder.
    if (( ${SIMPLE_GIT_PULL:-1} )) && [[ $prompt_simple_vcs_info[top] != $HOME ]]; then
        zstyle -t :prompt:simple:git:fetch only_upstream
        local only_upstream=$((? == 0))
        async_job "prompt_simple" prompt_simple_async_git_fetch $only_upstream
    fi

    # If dirty checking is sufficiently fast,
    # tell the worker to check it again, or wait for timeout.
    integer time_since_last_dirty_check=$(( EPOCHSECONDS - ${prompt_simple_git_last_dirty_check_timestamp:-0} ))
    if (( time_since_last_dirty_check > ${SIMPLE_GIT_DELAY_DIRTY_CHECK:-1800} )); then
        unset prompt_simple_git_last_dirty_check_timestamp
        # Check check if there is anything to pull.
        async_job "prompt_simple" prompt_simple_async_git_dirty ${SIMPLE_GIT_UNTRACKED_DIRTY:-1}
    fi

}

prompt_simple_check_git_arrows() {
    setopt localoptions noshwordsplit
    local arrows left=${1:-0} right=${2:-0}

    (( right > 0 )) && arrows+=${SIMPLE_GIT_DOWN_ARROW:-⇣}
    (( left > 0 )) && arrows+=${SIMPLE_GIT_UP_ARROW:-⇡}

    [[ -n $arrows ]] || return
    typeset -g REPLY=$arrows
}

prompt_simple_async_callback() {
    setopt localoptions noshwordsplit
    local job=$1 code=$2 output=$3 exec_time=$4 next_pending=$6
    local do_render=0

    case $job in
        \[async])
            # Handle all the errors that could indicate a crashed
            # async worker. See zsh-async documentation for the
            # definition of the exit codes.
            if (( code == 2 )) || (( code == 3 )) || (( code == 130 )); then
                # Our worker died unexpectedly, try to recover immediately.
                # TODO(mafredri): Do we need to handle next_pending
                #                 and defer the restart?
                typeset -g prompt_simple_async_inited=0
                async_stop_worker prompt_simple
                prompt_simple_async_init   # Reinit the worker.
                prompt_simple_async_tasks  # Restart all tasks.
            fi
            ;;
        \[async/eval])
            if (( code )); then
                # Looks like async_worker_eval failed,
                # rerun async tasks just in case.
                prompt_simple_async_tasks
            fi
            ;;
        prompt_simple_async_vcs_info)
            local -A info
            typeset -gA prompt_simple_vcs_info

            # Parse output (z) and unquote as array (Q@).
            info=("${(Q@)${(z)output}}")
            local -H MATCH MBEGIN MEND
            if [[ $info[pwd] != $PWD ]]; then
                # The path has changed since the check started, abort.
                return
            fi
            # Check if Git top-level has changed.
            if [[ $info[top] = $prompt_simple_vcs_info[top] ]]; then
                # If the stored pwd is part of $PWD, $PWD is shorter and likelier
                # to be top-level, so we update pwd.
                if [[ $prompt_simple_vcs_info[pwd] = ${PWD}* ]]; then
                    prompt_simple_vcs_info[pwd]=$PWD
                fi
            else
                # Store $PWD to detect if we (maybe) left the Git path.
                prompt_simple_vcs_info[pwd]=$PWD
            fi
            unset MATCH MBEGIN MEND

            # The update has a Git top-level set, which means we just entered a new
            # Git directory. Run the async refresh tasks.
            [[ -n $info[top] ]] && [[ -z $prompt_simple_vcs_info[top] ]] && prompt_simple_async_refresh

            # Always update branch, top-level and stash.
            prompt_simple_vcs_info[branch]=$info[branch]
            prompt_simple_vcs_info[top]=$info[top]
            prompt_simple_vcs_info[action]=$info[action]

            do_render=1
            ;;
        prompt_simple_async_git_aliases)
            if [[ -n $output ]]; then
                # Append custom Git aliases to the predefined ones.
                prompt_simple_git_fetch_pattern+="|$output"
            fi
            ;;
        prompt_simple_async_git_dirty)
            local prev_dirty=$prompt_simple_git_dirty
            if (( code == 0 )); then
                unset prompt_simple_git_dirty
            else
                typeset -g prompt_simple_git_dirty="*"
            fi

            [[ $prev_dirty != $prompt_simple_git_dirty ]] && do_render=1

            # When `prompt_simple_git_last_dirty_check_timestamp` is set, the Git info is displayed
            # in a different color. To distinguish between a "fresh" and a "cached" result, the
            # preprompt is rendered before setting this variable. Thus, only upon the next
            # rendering of the preprompt will the result appear in a different color.
            (( $exec_time > 5 )) && prompt_simple_git_last_dirty_check_timestamp=$EPOCHSECONDS
            ;;
        prompt_simple_async_git_fetch|prompt_simple_async_git_arrows)
            # `prompt_simple_async_git_fetch` executes `prompt_simple_async_git_arrows`
            # after a successful fetch.
            case $code in
                0)
                    local REPLY
                    prompt_simple_check_git_arrows ${(ps:\t:)output}
                    if [[ $prompt_simple_git_arrows != $REPLY ]]; then
                        typeset -g prompt_simple_git_arrows=$REPLY
                        do_render=1
                    fi
                    ;;
                97)
                    # No remote available, make sure to clear git arrows if set.
                    if [[ -n $prompt_simple_git_arrows ]]; then
                        typeset -g prompt_simple_git_arrows=
                        do_render=1
                    fi
                    ;;
                99|98)
                    # Git fetch failed.
                    ;;
                *)
                    # Non-zero exit status from `prompt_simple_async_git_arrows`,
                    # indicating that there is no upstream configured.
                    if [[ -n $prompt_simple_git_arrows ]]; then
                        unset prompt_simple_git_arrows
                        do_render=1
                    fi
                    ;;
            esac
            ;;
    esac
}

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

prompt_simple_reset_prompt() {
    if [[ $CONTEXT == cont ]]; then
        # When the context is "cont", PS2 is active and calling
        # reset-prompt will have no effect on PS1, but it will
        # reset the execution context (%_) of PS2 which we don't
        # want. Unfortunately, we can't save the output of "%_"
        # either because it is only ever rendered as part of the
        # prompt, expanding in-place won't work.
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

    # We can't perform a prompt reset at this point because it
    # removes the prompt marks inserted by macOS Terminal.
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
}

prompt_simple_precmd() {
    setopt localoptions noshwordsplit

    # Check execution time and store it in a variable.
    prompt_simple_check_cmd_exec_time
    unset prompt_simple_cmd_timestamp

    # Modify the colors if some have changed..
    prompt_simple_set_colors

    # Perform async Git dirty check and fetch.
    prompt_simple_async_tasks

    # Make sure VIM prompt is reset.
    prompt_simple_reset_prompt_symbol

    # Print the preprompt.
    prompt_simple_preprompt_render "precmd"
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

prompt_simple_preprompt_render() {
    setopt localoptions noshwordsplit

    # Set color for Git branch/dirty status and change color if dirty checking has been delayed.
    local git_color=$prompt_simple_colors[git:branch]
    local git_dirty_color=$prompt_simple_colors[git:dirty]
    [[ -n ${prompt_simple_git_last_dirty_check_timestamp+x} ]] && git_color=$prompt_simple_colors[git:branch:cached]

    # Initialize the preprompt array.

    local -a rpreprompt_parts
    # Git branch and dirty status info.
    typeset -gA prompt_simple_vcs_info
    if [[ -n $prompt_simple_vcs_info[branch] ]]; then
        rpreprompt_parts+=("%F{$git_color}"'${prompt_simple_vcs_info[branch]}'"%F{$git_dirty_color}"'${prompt_simple_git_dirty}%f')
    fi
    # Git action (for example, merge).
    if [[ -n prompt_simple_vcs_info[action] ]]; then
        rpreprompt_parts+=("%F{$prompt_simple_colors[git:action]}"'$prompt_simple_vcs_info[action]%f')
    fi
    # Git pull/push arrows.
    if [[ -n $prompt_simple_git_arrows ]]; then
        rpreprompt_parts+=('%F{$prompt_simple_colors[git:arrow]}${prompt_simple_git_arrows}%f')
    fi
    # Execution time. will be set for
    [[ -n $prompt_simple_cmd_exec_time ]] && rpreprompt_parts+=(' %F{$prompt_simple_colors[execution_time]}${prompt_simple_cmd_exec_time}%f')

    RPROMPT="${(j..)rpreprompt_parts}"
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
    username='%F{$prompt_simple_colors[user]}%n%f'
    # Show `username@host` if logged in through
    [[ -n $ssh_connection ]] && username='%F{$prompt_simple_colors[user]}%n%f'"$hostname"
    # Show `username@host` if root, with username in default color.
    [[ $UID -eq 0 ]] && username='%F{$prompt_simple_colors[user:root]}%n%f'"$hostname"

    typeset -gA prompt_simple_state
    prompt_simple_state+=(
    username "$username"
    accent "${SIMPLE_PROMPT_ACCENT:-::}"
    prompt	 "${SIMPLE_PROMPT_SYMBOL:-➜}"
)

    # Username and machine, if applicable.
    # Set the path.
    local -a prompt_parts
    [[ -n $prompt_simple_state[username] ]] && prompt_parts+=($prompt_simple_state[username]$prompt_simple_state[accent])
    prompt_parts+=('%F{${prompt_simple_colors[path]}}%c%f${prompt_simple_state[accent]} ')

    PROMPT=${(j..)prompt_parts}
}


prompt_simple_setup() {
    # Prevent percentage showing up if output doesn't end with a newline.
    export PROMPT_EOL_MARK=''

    prompt_opts=(subst percent)

    # Borrowed from `promptinit`. Sets the prompt options in case simple was not
    # initialized via `promptinit`.
    setopt noprompt{bang,cr,percent,subst} "prompt${^prompt_opts[@]}"

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
    )
    prompt_simple_colors=("${(@kv)prompt_simple_colors_default}")

    add-zsh-hook precmd prompt_simple_precmd
    add-zsh-hook preexec prompt_simple_preexec

    prompt_simple_state_setup

    zle -N prompt_simple_reset_prompt
    zle -N prompt_simple_update_vim_prompt_widget
    zle -N prompt_simple_reset_vim_prompt_widget
    if (( $+functions[add-zle-hook-widget] )); then
        add-zle-hook-widget zle-line-finish prompt_simple_reset_vim_prompt_widget
        add-zle-hook-widget zle-keymap-select prompt_simple_update_vim_prompt_widget
    fi

    local prompt_indicator='%(?.%F{$prompt_simple_colors[prompt:success]}.%F{$prompt_simple_colors[prompt:error]})${prompt_simple_state[prompt]}%f '
    PROMPT+=$prompt_indicator
}

prompt_simple_setup "$@"
