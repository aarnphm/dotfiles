#!/usr/bin/env sh

set -e

if [[ ! `command -v chezmoi` ]]; then
    curl -sfL https://git.io/chezmoi | sh
fi

if [[ `uname -s` == "Linux" ]]; then
    ./arch_bootstrap.sh
fi

./chezmoi_bootstrap.sh

