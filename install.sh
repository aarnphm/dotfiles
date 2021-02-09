#!/usr/bin/env sh

set -euo pipefail

# Test if $1 is available
isavailable() {
    type "$1" &>/dev/null
}

echo "Install reqquired dependencies"
if [[ `$OSTYPE` == "darwin"* ]]; then
    make homebrew-install
elif [[ `$OSTYPE` == "linux-gnu"* ]]; then
    is available chezmoi || sudo pacman -S chezmoi --noconfirm
fi

make all
