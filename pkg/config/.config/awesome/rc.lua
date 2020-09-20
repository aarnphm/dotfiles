-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local lain  = require("lain")

-- Autofocus a new client when previously focused one is closed
require("awful.autofocus")
-- Import theme
local beautiful = require("beautiful")
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

-- Notification library
local naughty = require("naughty")

-- Import Tag Settings
local tags = require("tags")

-- Import Keybinds
local keys = require("keys")
root.keys(keys.globalkeys)
root.buttons(keys.desktopbuttons)

-- Import rules
local create_rules = require("rules").create
awful.rules.rules = create_rules(keys.clientkeys, keys.clientbuttons)

local tyrannical = require("tyrannical")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- ===================================================================
-- Set Up Tags
-- ===================================================================

-- Define tag layouts
awful.util.tagnames = tags
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.floating,
 }

-- lain.layout.termfair.nmaster           = 3
-- lain.layout.termfair.ncol              = 1
-- lain.layout.termfair.center.nmaster    = 3
-- lain.layout.termfair.center.ncol       = 1
-- lain.layout.cascade.tile.offset_x      = 2
-- lain.layout.cascade.tile.offset_y      = 32
-- lain.layout.cascade.tile.extra_padding = 5
-- lain.layout.cascade.tile.nmaster       = 5
-- lain.layout.cascade.tile.ncol          = 2

awful.util.taglist_buttons = keys.taglist_buttons
awful.util.tasklist_buttons = keys.tasklist_buttons

screen.connect_signal("request::wallpaper", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

-- First, set some settings
tyrannical.settings.default_layout =  awful.layout.suit.tile
-- tyrannical.settings.master_width_factor = 0.66

-- Setup some tags
tyrannical.tags = {
  {
    name        = tags[1],             
    init        = true,                  
    exclusive   = true,                 
    screen      = {1,2},                     
    layout      = awful.layout.suit.tile,
    selected    = true,
    class       = { --Accept the following classes, refuse everything else (because of "exclusive=true")
      "xterm" , "urxvt" , "alacritty" ,"Code","termite"
    }
  } ,
  {
    name        = tags[2],
    init        = true,
    exclusive   = false,
    screen      = {1,2},      -- Setup on screen 2 if there is more than 1 screen, else on screen 1
    layout      = awful.layout.suit.spiral.dwindle,
    class = {"Firefox", "Chrome"}
  } ,
  {
    name = tags[3],
    init        = true,
    exclusive   = true,
    screen      = {1,2},
    layout      = awful.layout.suit.max,
    class  = {"spotify"}, --When the tag is accessed for the first time, execute this command
  } ,
  {
    name = tags[4],
    init        = true,
    exclusive   = true,
    screen      = {1,2},
    layout      = awful.layout.suit.tile,
    class ={"Firefox", "Notion","foxitreader"}
  } ,
  {
    name        = tags[5],
    init        = true,
    screen      = {1,2},
    exclusive   = false,
    layout      = awful.layout.suit.floating,
    class       = {"teams", "zoom", "skype"} ,
  },
  {
    name        = tags[6],
    init        = true,
    exclusive   = false,
    screen      = {1,2},
    layout      = awful.layout.suit.tile,
    class       = {"steam", "discord"} ,
}
}

-- Ignore the tag "exclusive" property for the following clients (matched by classes)
tyrannical.properties.intrusive = {"feh","gcr-prompter"}

-- Ignore the tiled layout for the matching clients
tyrannical.properties.floating = {"feh"}

-- Make the matching clients (by classes) on top of the default layout
tyrannical.properties.ontop = {"rofi"}

-- Force the matching clients (by classes) to be centered on the screen on init
tyrannical.properties.centered = {"kcalc"}

-- Do not honor size hints request for those classes
tyrannical.properties.size_hints_honor = { xterm = false, URxvt = false, alacritty = false, termite = false}

-- ===================================================================
-- Set Up Screen & Connect Signals
-- ===================================================================

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)

-- No borders when rearranging only 1 non-floating or maximized client
screen.connect_signal("arrange", function (s)
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        if only_one and not c.floating or c.maximized then
            c.border_width = 0
        else
            c.border_width = beautiful.border_width
        end
    end
end
)

-- ===================================================================
-- Garbage collection (allows for lower memory consumption)
-- ===================================================================

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
