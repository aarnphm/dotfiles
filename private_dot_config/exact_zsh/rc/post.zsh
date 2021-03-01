
#--------------------------------------------------------------#
##          Post Execution                                    ##
#--------------------------------------------------------------#

(
    setopt LOCAL_OPTIONS EXTENDED_GLOB
    autoload -U zrecompile

    # Compile zcompdump, if modified, to increase startup speed.
    zcompdump="$ZDOTDIR/.zcompdump"
    if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
        zrecompile -pq "$zcompdump"
    fi
) &!

if ! builtin command -v compinit > /dev/null 2>&1; then
  autoload -Uz compinit && compinit -u
fi

# start ssh
SSH_ENV="$HOME/.ssh/agent-environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' >| "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" >/dev/null
    /usr/bin/ssh-add;
}

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" >/dev/null
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent >/dev/null || start_agent;
else
    start_agent;
fi
