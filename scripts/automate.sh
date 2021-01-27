#!/bin/bash

# get datetime
datetime=$(date +'%a %m-%d %R %Z')

# execute scripts
cd $HOME/dotfiles && git add .
git commit -am "$datetime: updates"
git push

