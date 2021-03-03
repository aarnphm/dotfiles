#--------------------------------------------------------------#
##          Post Execution                                    ##
#--------------------------------------------------------------#
if ! builtin command -v compinit > /dev/null 2>&1; then
    autoload -Uz compinit
    if [ $(date +'%j') != $(/usr/bin/stat -f '%Sm' -t '%j' ${ZDOTDIR:-$HOME}/.zcompdump) ]; then
        compinit
    else
        compinit -C
    fi
fi
