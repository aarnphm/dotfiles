#!/usr/bin/env sh

set -euo pipefail

# Test if $1 is available
isavailable() {
    type "$1" &>/dev/null
}

if [[ `$OSTYPE` == "linux-gnu"* ]]; then
    is available chezmoi || sudo pacman -S chezmoi --noconfirm
    ./arch_bootstrap.sh
fi

./chezmoi_bootstrap.sh
