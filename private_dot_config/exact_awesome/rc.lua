-- ===================================================================
-- Standard Library
-- ===================================================================

pcall(require, "luarocks.loader")
local gears     = require("gears")
local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local helpers   = require("helpers")
-- Autofocus a new client when previously focused one is closed
require("awful.autofocus")

-- ===================================================================
-- Autostart Error handling
-- ===================================================================

require("autostart")
awesome.register_xproperty("WM_NAME", "string")

-- [DEPRECATED] spawn the shell scripts to run startup program
-- awful.spawn.with_shell("~/.config/awesome/autorun.sh")

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)

if awesome.startup_errors then
    naughty.notify(
        {
            preset = naughty.config.presets.critical,
            title = "Oops, there were errors during startup!",
            text = awesome.startup_errors
        }
        )
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal(
        "debug::error",
        function(err)
            -- Make sure we don't go into an endless error loop
            if in_error then
                return
            end
            in_error = true

            naughty.notify(
                {
                    preset = naughty.config.presets.critical,
                    title = "Oops, an error happened!",
                    text = tostring(err)
                }
                )
            in_error = false
        end
        )
end

-- ===================================================================
-- Apps & defaults
-- Also import some custom modules
-- ===================================================================

beautiful.init(gears.filesystem.get_configuration_dir() .. "theme/" .. require("defaults").theme .. "/theme.lua")

require("icons").init("default")

-- ===================================================================
-- Screen connect
-- ===================================================================

awful.screen.connect_for_each_screen(function(s)

    -- Each screen has its own tag table.
    awful.tag({ "", " ", " ", " ", " " }, s, awful.layout.layouts[2])
end)

-- ===================================================================
-- Keys
-- ===================================================================

require("keys")

-- ===================================================================
-- Rules setup
-- ===================================================================

awful.rules.rules = require("rules")

-- ===================================================================
-- Signal and misc imports
-- ===================================================================

client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end
)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus",
function(c) c.border_color = beautiful.border_focus end)

client.connect_signal("unfocus",
function(c) c.border_color = beautiful.border_normal end)

require("components")
require("node")
-- fancy tag switching
require("collision")()

-- ===================================================================
-- Garbage collection (allows for lower memory consumption)
-- ===================================================================

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
