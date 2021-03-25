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

prompt_simple_async_git_arrows() {
	setopt localoptions noshwordsplit
	command git rev-list --left-right --count HEAD...@'{u}'
}

prompt_simple_async_git_stash() {
	git rev-list --walk-reflogs --count refs/stash
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

				# Reset render state due to restart.
				unset prompt_simple_async_render_requested
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
		prompt_simple_async_git_stash)
			local prev_stash=$prompt_simple_git_stash
			typeset -g prompt_simple_git_stash=$output
			[[ $prev_stash != $prompt_simple_git_stash ]] && do_render=1
			;;
	esac

	if (( next_pending )); then
		(( do_render )) && typeset -g prompt_simple_async_render_requested=1
		return
	fi

	[[ ${prompt_simple_async_render_requested:-$do_render} = 1 ]] && prompt_simple_prompt_render
	unset prompt_simple_async_render_requested
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
		unset prompt_simple_git_stash
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
	Fi

	# If stash is enabled, tell async worker to count stashes
	if zstyle -t ":prompt:simple:git:stash" show; then
		async_job "prompt_simple" prompt_simple_async_git_stash
	else
		unset prompt_simple_git_stash
	fi
}
# vim: set ft=zsh ts=2 sw=2 tw=0 et :
