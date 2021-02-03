#!/bin/bash

for d in pkg/*; do
    dir=$(basename $d);
    stow $dir --target=$HOME --ignore='stow.sh';
done
