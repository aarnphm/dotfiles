-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

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

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local apps = require("apps")
awful.util.terminal = apps.default.terminal

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
-- Set Up Screen & Connect Signals
-- ===================================================================

-- Define tag layouts
awful.util.tagnames = tags
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.floating,
 }

awful.util.taglist_buttons = keys.taglist_buttons
awful.util.tasklist_buttons = keys.tasklist_buttons

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
