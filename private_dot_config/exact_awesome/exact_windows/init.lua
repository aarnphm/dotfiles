local awful     = require("awful")
local gears     = require("gears")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = require("beautiful.xresources").apply_dpi
local helpers   = require("helpers")
local defaults  = require("defaults")
local modkey    = require("defaults").modkey
local altkey    = require("defaults").altkey
local gfs       = gears.filesystem

-- ===================================================================
-- Theme definition
-- ===================================================================

beautiful.init(gears.filesystem.get_configuration_dir() .. "decorations/theme/" .. defaults.theme .. "/theme.lua")

-- ===================================================================
-- Signal and misc imports
-- ===================================================================

screen.connect_signal("request::desktop_decoration", function(s)

    screen[s].padding = {left = 0, right = 0, top = 0, bottom = 0}
    awful.tag(defaults.tags[s.index].names, s, defaults.tags[s.index].layout)

end)

client.connect_signal("manage", function(c)

    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end
    if awesome.startup and not c.size_hints.user_position and
        not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    -- Give ST and termite icon
    if c.class == "st" or c.class == "xterm" then
        local new_icon = gears.surface(gfs.get_configuration_dir() .. "decorations/icons/terminal.png")
        c.icon = new_icon._native
    end
end)

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

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)

client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Hide all windows when a splash is shown
awesome.connect_signal("widgets::splash::visibility", function(vis)
    local t = awful.screen.focused().selected_tag
    if vis then
        for idx, c in ipairs(t:clients()) do c.hidden = true end
    else
        for idx, c in ipairs(t:clients()) do c.hidden = false end
    end
end)
