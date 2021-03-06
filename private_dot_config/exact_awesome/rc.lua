-- ===================================================================
-- Standard Library
-- ===================================================================

pcall(require, "luarocks.loader")
local gears     = require("gears")
local awful     = require("awful")
local beautiful = require("beautiful")
local defaults  = require("defaults")
-- Autofocus a new client when previously focused one is closed
require("awful.autofocus")

-- ===================================================================
-- Autostart Error handling
-- ===================================================================

-- the shell scripts is used to run some daemon
awful.spawn.with_shell("$XDG_CONFIG_HOME/awesome/X/run_once.sh")
awesome.register_xproperty("WM_NAME", "string")

-- startup some applications
os.execute("~/.local/bin/xsettingsd-setup")
os.execute("~/.local/bin/ssh-add")
awful.spawn.with_shell("~/.local/bin/auto-lock start")

-- ===================================================================
-- Apps & defaults
-- Also import some custom modules
-- ===================================================================

beautiful.init(gears.filesystem.get_configuration_dir() .. "theme/" .. defaults.theme .. "/theme.lua")
require("windows")
require("daemon")

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
-- Daemon and modules
-- ===================================================================

require("components")

-- ===================================================================
-- Garbage collection (allows for lower memory consumption)
-- ===================================================================

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
