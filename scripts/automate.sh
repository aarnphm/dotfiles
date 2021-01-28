#!/bin/bash

# get datetime
datetime=$(date +'%a%m-%d%R')

# execute scripts
HOME=/home/aarnphm
cd $HOME/dotfiles && git add .
git commit -am "$datetime: cron updates"
git push --all

