--Place this file in your .xmonad/lib directory and import module Colors into .xmonad/xmonad.hs config
--The easy way is to create a soft link from this file to the file in .xmonad/lib using ln -s
--Then recompile and restart xmonad.

module Colors
    ( wallpaper
    , background, foreground, cursor
    , color0, color1, color2, color3, color4, color5, color6, color7
    , color8, color9, color10, color11, color12, color13, color14, color15
    ) where

-- Shell variables
-- Generated by 'wal'
wallpaper="/home/david/.config/wpg/wallpapers/wallpaper.jpg"

-- Special
background="#090610"
foreground="#acc2d2"
cursor="#acc2d2"

-- Colors
color0="#090610"
color1="#92216E"
color2="#87417E"
color3="#665B94"
color4="#A7328E"
color5="#9F53A4"
color6="#CC57C2"
color7="#acc2d2"
color8="#788793"
color9="#92216E"
color10="#87417E"
color11="#665B94"
color12="#A7328E"
color13="#9F53A4"
color14="#CC57C2"
color15="#acc2d2"