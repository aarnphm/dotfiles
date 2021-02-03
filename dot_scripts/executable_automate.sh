#!/usr/bin/env bash

# get datetime
datetime=$(date +'%a:%m-%d:%R')

cd $HOME/dotfiles 

# Check if upstream, else not pull
if [ $(git rev-parse @)==$(git merge-base @ ${1:-'@{u}'}) ]; then
    git pull --recurse-submodules
fi

# execute scripts
git add .&& git commit -am "$datetime: cron updates" && git push --all

