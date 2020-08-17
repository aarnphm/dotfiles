#!/bin/bash
for d in pkg/*; do
    dir=$(basename $d);
    stow $dir --target=$HOME;
    echo "finish stowing"
done
