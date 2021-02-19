-- default.lua
-- Wibar (top bar)
local awful          = require("awful")
local gears          = require("gears")
local wibox          = require("wibox")
local beautiful      = require("beautiful")
local xresources     = require("beautiful.xresources")
local dpi            = xresources.apply_dpi
local helpers        = require("helpers")
local defaults       = require("defaults")
local modkey         = require("defaults").modkey
local icons          = require("icons")

-- Helper function that changes the appearance of progress bars and their icons
-- Create horizontal rounded bars
local function format_progress_bar(bar)
    bar.forced_width = dpi(100)
    bar.shape = helpers.rrect(beautiful.border_radius - 3)
    bar.bar_shape = helpers.rrect(beautiful.border_radius - 3)
    bar.background_color = beautiful.xcolor0
    return bar
end

-- ===================================================================
-- Awesome panel
-- ===================================================================

local panelPop = require('node.popup.panel')
local awesome_icon = wibox.widget {
    {
        {widget = wibox.widget.imagebox, image = icons.awesome, resize = true},
        margins = 2,
        widget = wibox.container.margin
    },
    bg = beautiful.xbackground,
    widget = wibox.container.background
}


awesome_icon:buttons(gears.table.join(
        awful.button({}, 1, function()
            panelPop.visible = true
            awesome_icon.bg = beautiful.xcolor0
        end),
        awful.button({}, 3, function()
            panelPop.visible = false
            awesome_icon.bg = beautiful.xbackground
        end)
        )
    )

awesome_icon:connect_signal("mouse::enter",
function() panelPop.visible = true end)
-- awesome_icon:connect_signal("mouse::leave",
-- function() panelPop.visible = false end)

panelPop:connect_signal("mouse::leave", function()
    panelPop.visible = false
    awesome_icon.bg = beautiful.xbackground
end)

-- ===================================================================
--  Battery Bar Widget
-- ===================================================================

local battery_bar = require("node.widgets.battery_bar")
local battery = format_progress_bar(battery_bar)

-- ===================================================================
-- Systray widgets
-- ===================================================================

local mysystray = wibox.widget.systray()
mysystray:set_base_size(beautiful.systray_icon_size)

local mysystray_container = {
    mysystray,
    left = dpi(10),
    right = dpi(10),
    widget = wibox.container.margin
}

-- ===================================================================
-- Taglist widgets
-- ===================================================================

local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({modkey}, 1, function(t)
        if client.focus then client.focus:move_to_tag(t) end
    end), awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({modkey}, 3, function(t)
        if client.focus then client.focus:toggle_tag(t) end
    end), awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
    )

-- ===================================================================
-- Tasklist widgets
-- ===================================================================

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", {raise = true})
        end
    end), awful.button({}, 3, function()
        awful.menu.client_list({theme = {width = 250}})
    end), awful.button({}, 4, function() awful.client.focus.byidx(1) end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end)
    )

-- ===================================================================
-- Create wibar
-- ===================================================================

awful.screen.connect_for_each_screen(function(s)

    awful.tag(defaults.tags[s.index].names, s, defaults.tags[s.index].layout)
    -- Create layoutbox widget
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
            awful.button({}, 1, function () awful.layout.inc( 1) end),
            awful.button({}, 3, function () awful.layout.inc(-1) end),
            awful.button({}, 4, function () awful.layout.inc( 1) end),
        awful.button({}, 5, function () awful.layout.inc(-1) end)))

        if s.index == 1 then
            mysystray_container.visible = true
        else
            mysystray_container.visible = false
        end

        -- Create the wibox
        s.mywibox = awful.wibar({position = "top", screen = s, ontop = true, bg = beautiful.bg_normal .. 15})
        s.mywibox:set_xproperty("WM_NAME", "panel")

        -- Remove wibar on full screen
        local function remove_wibar(c)
            if c.fullscreen or c.maximized then
                c.screen.mywibox.visible = false
            else
                c.screen.mywibox.visible = true
            end
        end

        client.connect_signal("property::fullscreen", remove_wibar)

        -- Create a taglist widget
        s.mytaglist = awful.widget.taglist({
                screen = s,
                filter = awful.widget.taglist.filter.all,
                style = {shape = gears.shape.rectangle},
                layout = {spacing = 0, layout = wibox.layout.fixed.horizontal},
                widget_template = {
                    {
                        {
                            {id = 'text_role', widget = wibox.widget.textbox},
                            layout = wibox.layout.fixed.horizontal
                        },
                        left = 11,
                        right = 11,
                        top = 1,
                        widget = wibox.container.margin
                    },
                    id = 'background_role',
                    widget = wibox.container.background
                },
                buttons = taglist_buttons
            })

        -- Create a tasklist widget
        s.mytasklist = awful.widget.tasklist {
            screen = s,
            filter = awful.widget.tasklist.filter.currenttags,
            buttons = tasklist_buttons,
            style = {
                bg = beautiful.xbackground,
                font = beautiful.font,
            },
            layout = {spacing = 10, layout = wibox.layout.fixed.horizontal},
            widget_template = {
                {
                    {
                        nil,
                        {id = 'text_role', widget = wibox.widget.textbox},
                        nil,
                        layout = wibox.layout.fixed.horizontal
                    },
                    left = dpi(12),
                    right = dpi(12),
                    top = dpi(0),
                    widget = wibox.container.margin
                },
                id = 'background_role',
                widget = wibox.container.background
            }
        }

        -- Add widgets to the wibox
        s.mywibox:setup{
            layout = wibox.layout.fixed.vertical,
            {
                widget = wibox.container.background,
                bg = beautiful.xcolor0,
                forced_height = 1
            },
            {
                layout = wibox.layout.align.horizontal,
                expand = "none",
                {
                    layout = wibox.layout.fixed.horizontal,
                    {
                        {
                            awesome_icon,
                            bg = beautiful.xcolor0,
                            shape = helpers.rrect(beautiful.border_radius - 3),
                            widget = wibox.container.background
                        },
                        top = 5,
                        right = 5,
                        left = 5,
                        bottom = 5,
                        widget = wibox.container.margin
                    },
                    {
                        {
                            s.mytaglist,
                            bg = beautiful.xcolor0,
                            shape = helpers.rrect(beautiful.border_radius - 3),
                            widget = wibox.container.background
                        },
                        top = 5,
                        bottom = 5,
                        right = 5,
                        left = 5,
                        widget = wibox.container.margin
                    },
                },
                {
                    s.mytasklist,
                    top = 5,
                    bottom = 5,
                    right = 5,
                    left = 5,
                    widget = wibox.container.margin,
                    forced_width = 400
                },
                {
                    {
                        {
                            {
                                battery,
                                top = 5,
                                bottom = 5,
                                right = 5,
                                left = 5,
                                widget = wibox.container.margin
                            },
                            bg = beautiful.xcolor0,
                            shape = helpers.rrect(beautiful.border_radius - 3),
                            widget = wibox.container.background
                        },
                        top = 5,
                        bottom = 5,
                        right = 5,
                        left = 5,
                        widget = wibox.container.margin
                    },
                    nil,
                    nil,
                    {
                        {
                            {
                                mysystray_container,
                                top = dpi(3),
                                layout = wibox.container.margin
                            },
                            bg = beautiful.xcolor0,
                            shape = helpers.rrect(beautiful.border_radius - 3),
                            widget = wibox.container.background
                        },
                        top = 5,
                        bottom = 5,
                        right = 5,
                        left = 5,
                        widget = wibox.container.margin
                    },
                    {
                        {
                            {
                                s.mylayoutbox,
                                top = dpi(4),
                                bottom = dpi(4),
                                right = dpi(7),
                                left = dpi(7),
                                widget = wibox.container.margin
                            },
                            bg = beautiful.xcolor0,
                            shape = helpers.rrect(beautiful.border_radius - 3),
                            widget = wibox.container.background
                        },
                        top = 5,
                        bottom = 5,
                        right = 5,
                        left = 5,
                        widget = wibox.container.margin
                    },

                    layout = wibox.layout.fixed.horizontal
                }
            }
        }
    end)
