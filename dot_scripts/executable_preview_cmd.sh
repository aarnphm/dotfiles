#!/usr/bin/env bash

# Check FIFO
NNN_FIFO=${NNN_FIFO:-$1}
if [ ! -r "$NNN_FIFO" ]; then
    echo "Unable to open \$NNN_FIFO='$NNN_FIFO'" | less
    exit 2
fi

# Read selection from $NNN_FIFO
while read -r selection; do
    clear
    lines=$(($(tput lines)-1))
    cols=$(tput cols)

    # Print directory tree
    if [ -d "$selection" ]; then
        cd "$selection" || continue
        tree | head -n $lines | cut -c 1-"$cols"
        continue
    fi

    # Print file head
    if [ -f "$selection" ]; then
        head -n $lines "$selection" | cut -c 1-"$cols"
        continue
    fi

    # Something went wrong
    echo "Unknown type: '$selection'"
done < "$NNN_FIFO"
