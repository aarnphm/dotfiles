#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Test if $1 is available
isavailable() {
    type "$1" &>/dev/null
}

if ! [ -x "$(command -v chezmoi)" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        isavailable brew || curl -sfL https://git.io/chezmoi | sh
        isavailable brew && brew install chezmoi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        isavailable chezmoi || sudo pacman -S chezmoi --noconfirm
    fi
else
    echo "Chezmoi exists, skipping."
fi

# # POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
# script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"
# # exec: replace current process with chezmoi init
# exec chezmoi init --apply "--source=$script_dir"
