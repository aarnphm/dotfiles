#!/bin/bash

# get datetime
datetime=$(date +'%a:%m-%d:%R')

# copy lightdm configs to scripts

if [ `uname -s` == "Linux" ]; then
    LIGHTDM_DIR=/etc/lightdm
    sudo cp $LIGHTDM_DIR/lightdm.conf $LIGHTDM_DIR/lightdm-mini-greeter.conf $HOME/dotfiles/scripts
fi

cd $HOME/dotfiles && git pull --recurse-submodules

# execute scripts
git add .
git commit -am "$datetime: cron updates"
git push --all

