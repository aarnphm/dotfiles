#!/bin/bash

. ../init/helpers.sh

for d in pkg/*; do
    dir=$(basename $d);
    echo_info "Stowing ${dir}..."
    stow $dir --target=$HOME --ignore=refind;
done
echo_info "Finished stowing. Enjoy!"
