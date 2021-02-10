#!/usr/bin/env bash
set -euo pipefail

# Test if $1 is available
isavailable() {
    type "$1" &>/dev/null
}

if [[ `command -v brew` ]]; then
    isavailable chezmoi || brew install chezmoi
else
    isavailable chezmoi || sudo pacman -S chezmoi --noconfirm
fi
