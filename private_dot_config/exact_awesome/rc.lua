-- ===================================================================
-- Standard Library
-- ===================================================================

pcall(require, "luarocks.loader")
local gears      = require("gears")
local awful      = require("awful")
local beautiful  = require("beautiful")
local naughty    = require("naughty")
local defaults   = require("defaults")
local components = require("components")
-- Autofocus a new client when previously focused one is closed
require("awful.autofocus")

-- ===================================================================
-- Autostart Error handling
-- ===================================================================

-- the shell scripts is used to run some daemon
awful.spawn.with_shell("~/.config/awesome/runonce.sh")
awesome.register_xproperty("WM_NAME", "string")

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title = "Oops, an error happened" ..
            (startup and " during startup!" or "!"),
        message = message
    }
end)

-- ===================================================================
-- Apps & defaults
-- Also import some custom modules
-- ===================================================================

beautiful.init(gears.filesystem.get_configuration_dir() .. "theme/" .. defaults.theme .. "/theme.lua")
-- components.playerctl.enable()
require("window")

-- ===================================================================
-- Signal and misc imports
-- ===================================================================

screen.connect_signal("request::desktop_decoration", function(s)

    screen[s].padding = {left = 0, right = 0, top = 0, bottom = 0}
    awful.tag(defaults.tags[s.index].names, s, defaults.tags[s.index].layout)

end)

-- ===================================================================
-- Keys
-- ===================================================================

require("keys")

-- ===================================================================
-- Rules setup
-- ===================================================================

require("rules")

-- ===================================================================
-- Garbage collection (allows for lower memory consumption)
-- ===================================================================

require("components")
require("node")
-- fancy tag switching
require("collision")()

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
