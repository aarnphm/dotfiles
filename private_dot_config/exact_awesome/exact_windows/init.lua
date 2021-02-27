local awful     = require("awful")
local gears     = require("gears")
local gfs       = gears.filesystem
local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = require("beautiful.xresources").apply_dpi
local helpers   = require("helpers")
local modkey    = require("defaults").modkey
local altkey    = require("defaults").altkey

-- This is to slave windows' positions in floating layout
-- Not Mine
-- https://github.com/larkery/awesome/blob/master/savefloats.lua
require("windows.savefloats")
-- Better mouse resizing on tiled
-- Not mine
-- https://github.com/larkery/awesome/blob/master/better-resize.lua
require("windows.better-resize")

client.connect_signal("manage", function(c)

    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end
    if awesome.startup and not c.size_hints.user_position and
        not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    -- Give ST and icon
    if c.class == "kitty" or c.class == "st" or c.class == "alacritty"  or c.class == "termite" then
        local new_icon = gears.surface(gfs.get_configuration_dir() .. "icons/default/terminal.png")
        c.icon = new_icon._native
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)

client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Restore geometry for floating clients
-- (for example after swapping from tiling mode to floating mode)
-- ==============================================================
tag.connect_signal('property::layout', function(t)
    for k, c in ipairs(t:clients()) do
        if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
            local cgeo = awful.client.property.get(c, 'floating_geometry')
            if cgeo then
                c:geometry(awful.client.property.get(c, 'floating_geometry'))
            end
        end
    end
end)

client.connect_signal('manage', function(c)
    if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
        awful.client.property.set(c, 'floating_geometry', c:geometry())
    end
end)

client.connect_signal('property::geometry', function(c)
    if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
        awful.client.property.set(c, 'floating_geometry', c:geometry())
    end
end)

-- ==============================================================
-- ==============================================================

-- When switching to a tag with urgent clients, raise them.
-- This fixes the issue (visual mismatch) where after switching to
-- a tag which includes an urgent client, the urgent client is
-- unfocused but still covers all other windows (even the currently
-- focused window).
awful.tag.attached_connect_signal(s, "property::selected", function ()
    local urgent_clients = function (c)
        return awful.rules.match(c, { urgent = true })
    end
    for c in awful.client.iterate(urgent_clients) do
        if c.first_tag == mouse.screen.selected_tag then
            client.focus = c
        end
    end
end)

-- Raise focused clients automatically
client.connect_signal("focus", function(c) c:raise() end)

-- Focus all urgent clients automatically
-- client.connect_signal("property::urgent", function(c)
--     if c.urgent then
--         c.minimized = false
--         c:jump_to()
--     end
-- end)

-- Disable ontop when the client is not floating, and restore ontop if needed
-- when the client is floating again
-- I never want a non floating client to be ontop.
client.connect_signal('property::floating', function(c)
    if c.floating then
        if c.restore_ontop then
            c.ontop = c.restore_ontop
        end
    else
        c.restore_ontop = c.ontop
        c.ontop = false
    end
end)

-- ===================================================================
-- Layoutlist widget
-- ===================================================================

-- List
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
    widget = wibox.widget {
        {ll, margins = dpi(24), widget = wibox.container.margin},
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
-- keybinds for widget
-- ===================================================================

-- Make sure you remove the default `Mod4+=` and `Mod4+Alt+=`
-- keybindings before adding this.
function gears.table.iterate_value(t, value, step_size, filter, star_at)
    local k = gears.table.hasitem(t, value, true, start_at)
    if not k then return end

    step_size = step_size or 1
    local new_key = gears.math.cycle(#t, k + step_size)

    if filter and not filter(t[new_key]) then
        for i = 1, #t do
            local k2 = gears.math.cycle(#t, new_key + i)
            if filter(t[k2]) then return t[k2], k2 end
        end
        return
    end

    return t[new_key], new_key
end

awful.keygrabber {
    start_callback = function() layout_popup.visible = true end,
    stop_callback = function() layout_popup.visible = false end,
    export_keybindings = true,
    stop_event = "release",
    stop_key = {"Escape", "Super_L", "Super_R", "Mod4"},
    keybindings = {
        {
            {modkey, altkey}, "=", function()
                awful.layout.set(gears.table.iterate_value(ll.layouts,
                                                           ll.current_layout, -1),
                                 nil)
            end
        }, {
            {modkey}, "=", function()
                awful.layout.set(gears.table.iterate_value(ll.layouts,
                                                           ll.current_layout, 1),
                                 nil)
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
