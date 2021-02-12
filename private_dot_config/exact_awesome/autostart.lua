local awful = require("awful")

local function run_once(cmd)
    local comm = cmd
    -- deal with pipeline
    local fs = cmd:find(' ')
    if fs then comm = cmd:sub(0, fs -1) end
    awful.spawn.easy_async_with_shell(string.format('pgrep -u $USER -x %s >/dev/null || (%s)', comm, cmd))
end

run_once("nm-applet")
run_once("ibus-daemon -drx")
run_once("nitrogen --restore")
run_once("unclutter -idle 1")
run_once("redshift")
run_once("blueman-tray")
run_once("caffeine")
run_once("discord")
run_once("spotify-tray")
run_once("picom -f")
run_once("optimus-manager-qt")
