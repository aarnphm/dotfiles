-- ===================================================================
-- Standard Library
-- ===================================================================

pcall(require, "luarocks.loader")
local gears     = require("gears")
local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = require("beautiful.xresources").apply_dpi
local naughty   = require("naughty")
local helpers   = require("helpers")
-- Autofocus a new client when previously focused one is closed
require("awful.autofocus")

-- ===================================================================
-- Autostart Error handling
-- ===================================================================

local autostart = require("autostart")
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

local apps = require("defaults").defaults
-- Theme
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme/" .. apps.theme .. "/theme.lua")
-- Layouts
require("layouts")

local icons = require("icons")
icons.init("def")

-- ===================================================================
-- Screen connect
-- ===================================================================

awful.screen.connect_for_each_screen(function(s)
    -- Screen padding
    screen[s].padding = {left = 0, right = 0, top = 0, bottom = 0}

    -- Each screen has its own tag table.
    awful.tag({ "", "", "", "", "ﭮ", },s, awful.layout.layouts[1])
end)

-- ===================================================================
-- Keys
-- ===================================================================

root.buttons(gears.table.join(awful.buttons({}, 4, awful.tag.viewnext),
    awful.buttons({}, 5, awful.tag.viewprev)))
require("keys")


-- ===================================================================
-- Rules setup
-- ===================================================================

awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            -- placement can also + awful.placement.no_overlap + awful.placement.no_offscreen
            placement = awful.placement.centered
        }
    },
    {rule = {}, properties = {}, callback = awful.client.setslave}, -- so items in tasklist have the right order
    {
        rule_any = {
            class = {"Nm-connection-editor", "Gnome-disks", "caffeine", "Arandr", "Zotero", "Blueman-manager",
                "Nitrogen", "Nvidia-settings", "Baobab", "Xmessage", "Skype", "Lxappearance", "Chatterino",
            "Zoom", "Gparted", "Pavucontrol", "Qt5ct", "Kvantum", "Grub-customizer"},
            name  = {"Library", "Chat", "Event Tester", "Settings"},
            role  = {"pop-up"},
            type  = {"dialog"}
        },
        properties = {floating = true}
    },
    {
        rule = {class = "Spotify"},
        properties = {screen = screen.count()>1 and 2 or 1, tag = awful.util.tagnames[4], switchtotag = true}
    },
    {
        rule = {class = "Kitty"},
        properties = {screen = screen.count()>1 and 2 or 1, tag = awful.util.tagnames[1], switchtotag = true}
    },
    {
        rule_any = {instance={"chromium","firefox"}},
        properties = {tag = awful.util.tagnames[3], switchtotag = true}
    },
    {
        rule_any = {class="Microsoft Teams - Preview", instance = {"zoom", "discord", "slack", "skype","caprine"}},
        properties = {screen=screen.count()>1 and 2 or 1, tag = awful.util.tagnames[5], switchtotag = true}
    },
    {rule = {class = "Gimp"}, properties = {maximized = true}},
    -- Rofi
    {rule = {instance = "rofi"}, properties = {maximized = false, ontop = true}},
    -- other terminal
    {rule_any = {instance = {"termite","alacritty"}}, properties = {maximized = false, ontop = true, floating = true}},
    -- File chooser dialog
    {
        rule_any = {role = "GtkFileChooserDialog"},
        properties = {floating = true, width = apps.screen_width * 0.55, height = apps.screen_height * 0.65}
    }
}

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
require("nod")
-- fancy tag switching
require("collision")()

-- ===================================================================
-- Garbage collection (allows for lower memory consumption)
-- ===================================================================

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
