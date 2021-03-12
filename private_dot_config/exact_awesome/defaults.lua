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
    filebrowser  = "firefox --new-window file:///home/aarnphm",
    browser      = os.getenv("BROWSER") or "firefox",
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
            names  = { "", " ", " ", " ", " " },
            layout = {layouts[2], layouts[2], layouts[8], layouts[10], layouts[10]},
        },
        {
            names  = { "", " ", " ", " ", " " },
            layout = {layouts[2], layouts[2], layouts[8], layouts[10], layouts[10]},
        },
        {
            names  = { "", " ", " ", " ", " " },
            layout = {layouts[4],layouts[4],layouts[4], layouts[10], layouts[10]},
        }
    },
}
return defaults
