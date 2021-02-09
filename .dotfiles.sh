#!/usr/bin/env sh

set -euo pipefail
trap "exit" INT

# Test if $1 is available
isavailable() {
    type "$1" &>/dev/null
}

echo "Install reqquired dependencies"
if [[ `uname -s` == "Darwin" ]]; then
    make homebrew-install
elif [[ `uname -s` == "Linux" ]]; then
    isavailable chezmoi || sudo pacman -S chezmoi --noconfirm
fi

make run && make init
