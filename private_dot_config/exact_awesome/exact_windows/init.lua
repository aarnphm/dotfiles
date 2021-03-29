local awful     = require("awful")
local gears     = require("gears")
local wibox     = require("wibox")
local helpers   = require("helpers")
local beautiful = require("beautiful")
local defaults  = require("defaults")
local ctrl      = defaults.ctrl
local modkey    = defaults.modkey
local gfs       = gears.filesystem

-- This is to slave windows' positions in floating layout
-- https://github.com/larkery/awesome/blob/master/savefloats.lua
require("windows.savefloats")

-- Better mouse resizing on tiled
-- https://github.com/larkery/awesome/blob/master/better-resize.lua
require("windows.better-resize")

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
    if c.class == "St" or c.class == "URxvt" or c.class == "Termite" then
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
client.connect_signal("mouse::enter", function(c) c:emit_signal("request::activate", "mouse_enter", {raise = false}) end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)

client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- ===================================================================
-- Layout list
-- ===================================================================
local ll = awful.widget.layoutlist {
    source = awful.widget.layoutlist.source.default_layouts, -- DOC_HIDE
    spacing = dpi(24),
    base_layout = wibox.widget {
        spacing = dpi(24),
        forced_num_cols = 4,
        layout = wibox.layout.grid.vertical
    },
    widget_template = {
        {
            {
                id = 'icon_role',
                forced_height = dpi(68),
                forced_width = dpi(68),
                widget = wibox.widget.imagebox
            },
            margins = dpi(24),
            widget = wibox.container.margin
        },
        id = 'background_role',
        forced_width = dpi(68),
        forced_height = dpi(68),
        widget = wibox.container.background
    }
}

-- Popup
local layout_popup = awful.popup {
    screen = awful.screen.focused(),
    widget = wibox.widget {
        {
            ll,
            margins = dpi(24),
            widget = wibox.container.margin
        },
        bg = beautiful.xbackground,
        shape = helpers.rrect(beautiful.border_radius),
        border_color = beautiful.widget_border_color,
        border_width = beautiful.widget_border_width,
        widget = wibox.container.background
    },
    placement = awful.placement.centered,
    ontop = true,
    visible = false,
    bg = beautiful.bg_normal .. "00"
}

-- ===================================================================
-- Layout List Keybinding
-- ===================================================================

-- Make sure you remove the default `Mod4+=` and `Mod4+Shift+=`
-- keybindings before adding this.

awful.keygrabber {
    start_callback = function() layout_popup.visible = true end,
    stop_callback = function() layout_popup.visible = false end,
    export_keybindings = true,
    stop_event = "release",
    stop_key = {"Escape", "Super_L", "Super_R", "Mod4"},
    keybindings = {
        {
            {modkey}, "-",
            function()
                awful.layout.set(gears.table.cycle_value(ll.layouts, ll.current_layout, -1), nil)
            end
        },
        {
            {modkey}, "=",
            function()
                awful.layout.set(gears.table.cycle_value(ll.layouts, ll.current_layout, 1), nil)
            end
        }
    }
}

-- Hide all windows when a splash is shown
awesome.connect_signal("widgets::splash::visibility", function(vis)
    local t = awful.screen.focused().selected_tag
    if vis then
        for idx, c in ipairs(t:clients()) do c.hidden = true end
    else
        for idx, c in ipairs(t:clients()) do c.hidden = false end
    end
end)

