#!/bin/bash

# get datetime
datetime=$(date +'%a %m-%d %R %Z')

# execute scripts
git add . 
git commit -m "$datetime: updates"
git push origin master

