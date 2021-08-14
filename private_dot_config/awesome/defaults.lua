local awful = require("awful")
local layouts   = awful.layout.layouts
local defaults = {
    -- ===================================================================
    -- modkey (Super) and altkey (Alt)
    -- ===================================================================
    modkey = "Mod4",
    altkey = "Mod1",
    ctrl   = "Control",
    shift  = "Shift",
    -- ===================================================================
    -- screen defaults
    -- ===================================================================
    screen_height = awful.screen.focused().geometry.height,
    screen_width  = awful.screen.focused().geometry.width,
    theme         = "powerdark",
    -- ===================================================================
    -- default application
    -- ===================================================================
    terminal     = "kitty",
    editor       = "nvim",
    fileviewer   = "firefox --new-window file:///home/aarnphm",
    filebrowser  = "termite -e nnn",
    browser      = os.getenv("BROWSER") or "brave",
    spotify      = "spotify-tray",
    launcher     = "rofi -modi drun -i -p -show drun -show-icons",
    -- lock options uses xss-lock and xsecurelock
    lock         = "xset s activate",
    screenshot   = "gyazo",
    zotero       = "/opt/zotero/zotero",
    audiocontrol = "pavucontrol",
    bluetooth    = "blueman-manager",
    -- ===================================================================
    -- Tag definitions for screens
    -- ===================================================================
    -- TODO: are there others way to do this without manual labour?
    tags = {
        {
            names  = { " ", " ", " ", " ", " ", " ", " " },
            layout = {layouts[11], layouts[11], layouts[2], layouts[2], layouts[8], layouts[10]},
        },
        {
            names  = { " ", " ", " ", " ", " ", " ", " " },
            layout = {layouts[11], layouts[11], layouts[2], layouts[2], layouts[8], layouts[10]},
        },
        {
            names  = { " ", " ", " ", " ", " ", " ", " " },
            layout = {layouts[11], layouts[11], layouts[2], layouts[2], layouts[8], layouts[10]},
        },
    },
}
return defaults
-- vim: set ft=lua ts=4 sw=4 tw=0 et :
