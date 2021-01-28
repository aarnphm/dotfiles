#!/bin/bash

# get datetime
datetime=$(date +'%a:%m-%d:%R')

# copy lightdm configs to scripts
LIGHTDM_DIR=/etc/lightdm
cp $LIGHTDM_DIR/lightdm.conf $LIGHTDM_DIR/lightdm-mini-greeter.conf $HOME/dotfiles/scripts

# execute scripts
cd $HOME/dotfiles && git add .
git commit -am "$datetime: cron updates"
git push --all

