#!/bin/bash

# get datetime
datetime=$(date +'%a %m-%d %R %Z')

# execute scripts
HOME=/home/aarnphm
cd $HOME/dotfiles && git add .
git commit -am "$datetime: updates"
git push

