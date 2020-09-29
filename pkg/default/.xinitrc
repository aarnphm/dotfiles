# Make sure this is before the 'exec' command or it won't be sourced.
[ -f ~/.xprofile ] && . ~/.xprofile

exec awesome
# exec xmonad

