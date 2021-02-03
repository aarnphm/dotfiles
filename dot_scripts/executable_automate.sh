#!/usr/bin/env sh

set -e

if [ ! "$(command -v chezmoi)" ]; then
  bin_dir="$HOME/.local/bin"
  chezmoi="$bin_dir/chezmoi"
  if [ "$(command -v curl)" ]; then
    sh -c "$(curl -fsSL https://git.io/chezmoi)" -- -b "$bin_dir"
  elif [ "$(command -v wget)" ]; then
    sh -c "$(wget -qO- https://git.io/chezmoi)" -- -b "$bin_dir"
  else
    echo "To install chezmoi, you must have curl or wget installed." >&2
    exit 1
  fi
else
  chezmoi=chezmoi
fi

# get datetime
datetime=$(date +'%a:%m-%d:%R')

chezmoi cd

# Check if upstream, else not pull
if [ $(git rev-parse @)==$(git merge-base @ ${1:-'@{u}'}) ]; then
    git pull --recurse-submodules
fi

# execute scripts
git add .&& git commit -am "$datetime: cron chores" && git push --all

