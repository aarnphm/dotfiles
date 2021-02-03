#!/usr/bin/env sh

set -e

# get datetime
datetime=$(date +'%a:%m-%d:%R')

cd $HOME/.local/share/chezmoi
# Check if upstream, else not pull
if [ $(git rev-parse @)==$(git merge-base @ ${1:-'@{u}'}) ]; then
    git pull --recurse-submodules
fi

# execute scripts
git add .&& git commit -am "$datetime: cron chores" && git push --all

