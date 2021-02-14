local awful = require("awful")
local lay   = awful.layout.layouts
local defaults = {
    -- ===================================================================
    -- modkey (Super) and altkey (Alt)
    -- ===================================================================
    modkey        = "Mod4",
    altkey        = "Mod1",
    ctrl          = "Control",
    shift         = "Shift",
    -- ===================================================================
    -- screen defaults
    -- ===================================================================
    screen_height = awful.screen.focused().geometry.height,
    screen_width  = awful.screen.focused().geometry.width,
    theme         = "powerdark",
    -- ===================================================================
    -- default application
    -- ===================================================================
    terminal      = "kitty",
    editor        = "nvim",
    filebrowser   = "firefox --new-window file:///home/aarnphm",
    browser       = os.getenv("BROWSER") or "firefox",
    spotify       = "spotify-tray",
    launcher      = "rofi -modi drun -i -p -show drun -show-icons",
    lock          = "xsecurelock",
    screenshot    = "gyazo",
    zotero        = "/opt/zotero/zotero",
    audiocontrol  = "pavucontrol",
    bluetooth     = "blueman-manager",
    -- ===================================================================
    -- Tag definitions for screens
    -- ===================================================================
    tags = {
        {
            names = { "", " ", " ", " ", " " },
            layout = {lay[2], lay[1], lay[8], lay[10], lay[13]},
        },
        {
            names = { "", " ", " ", " ", " " },
            layout = lay[4],
        }
    },
}
return defaults
