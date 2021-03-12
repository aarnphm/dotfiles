-- bar.lua
local awful      = require("awful")
local gears      = require("gears")
local gfs        = require("gears.filesystem")
local wibox      = require("wibox")
local lain       = require("lain")
local beautiful  = require("beautiful")
local xresources = require("beautiful.xresources")
local helpers    = require("helpers")
local dpi        = xresources.apply_dpi

-- Helper function that changes the appearance of progress bars and their icons
-- Create horizontal rounded bars
local function format_progress_bar(bar)
    bar.forced_width = dpi(100)
    bar.shape = helpers.rrect(beautiful.border_radius - 3)
    bar.bar_shape = helpers.rrect(beautiful.border_radius - 3)
    bar.background_color = x.color0
    return bar
end

-- ===================================================================
-- Awesome panel
-- ===================================================================

local awesome_icon = wibox.widget {
    {
        {
            widget = wibox.widget.imagebox,
            image = gears.surface.load_uncached(gfs.get_configuration_dir() .. "decorations/icons/awesome.png"),
            resize = true
        },
        margins = dpi(6),
        widget = wibox.container.margin
    },
    bg = x.color0,
    shape = helpers.rrect(beautiful.border_radius - 3),
    widget = wibox.container.background
}

awesome_icon:buttons(gears.table.join(awful.button({}, 1, function()
    mymainmenu:toggle()
    awesome_icon.bg = x.color0
end)))

-- ===================================================================
-- Playerctl Bar widget
-- ===================================================================

local song_title = wibox.widget {
    markup = '--',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

local song_artist = wibox.widget {
    markup = '--',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

local song_logo = wibox.widget {
    markup = '<span foreground="' .. x.color6 .. '"> </span>',
    font = beautiful.icon_font,
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

local playerctl_bar = wibox.widget {
    {
        {
            {
                song_logo,
                left = dpi(3),
                right = dpi(10),
                widget = wibox.container.margin
            },
            {
                {
                    song_title,
                    expand = "outside",
                    layout = wibox.layout.align.vertical
                },
                left = dpi(10),
                right = dpi(10),
                widget = wibox.container.margin
            },
            {
                {
                    song_artist,
                    expand = "outside",
                    layout = wibox.layout.align.vertical
                },
                left = dpi(10),
                widget = wibox.container.margin
            },
            spacing = 1,
            spacing_widget = {
                bg = x.color8,
                widget = wibox.container.background
            },
            layout = wibox.layout.fixed.horizontal
        },
        left = dpi(10),
        right = dpi(10),
        widget = wibox.container.margin
    },
    bg = x.color0,
    shape = helpers.rrect(beautiful.border_radius - 3),
    widget = wibox.container.background
}

playerctl_bar.visible = false

-- Get Title
awesome.connect_signal("daemon::spotify", function(artist,title,playing)
    playerctl_bar.visible = true
    if playing ~= "Playing" then
        song_title.markup = '<span foreground="' .. x.color5 .. '">' ..
        title .. '</span>'

        song_artist.markup = '<span foreground="' .. x.color4 .. '">' ..
        artist .. '</span>'
    else
        song_title.markup = '--'
        song_artist.markup = '--'
    end
end
)

-- ===================================================================
-- Tasklist widgets
-- ===================================================================

tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", {raise = true})
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({theme = {width = 250}})
    end),
    awful.button({}, 4, function() awful.client.focus.byidx(1) end),
    awful.button({}, 5, function() awful.client.focus.byidx(-1) end)
    )

-- ===================================================================
--  Battery Bar Widget
-- ===================================================================

local battery_bar = wibox.widget {
    max_value = 100,
    value = 50,
    forced_width = dpi(200),
    shape = helpers.rrect(beautiful.border_radius - 3),
    bar_shape = helpers.rrect(beautiful.border_radius - 3),
    color = {
        type = 'linear',
        from = {0, 0},
        to = {75, 20},
        stops = {
            {0, x.color9}, {0.5, x.color11},
            {1, x.color10}
        }
    },
    background_color = x.color0,
    border_width = dpi(0),
    border_color = beautiful.border_color,
    widget = wibox.widget.progressbar
}

local battery_tooltip = awful.tooltip {}
battery_tooltip.shape = helpers.prrect(beautiful.border_radius - 3, false, false, false, false)
battery_tooltip.preferred_alignments = {"middle", "front", "back"}
battery_tooltip.mode = "outside"
battery_tooltip:add_to_object(battery_bar)
battery_tooltip.text = 'Not Updated'

awesome.connect_signal("daemon::battery", function(value)
    battery_bar.value = value
    battery_bar.color = {
        type = 'linear',
        from = {0, 0},
        to = {75 - (100 - value), 20},
        stops = {
            {1 + (value) / 100, x.color10},
            {0.75 - (value / 100), x.color9},
            {1 - (value) / 100, x.color10}
        }
    }

    local bat_icon = ' '

    if value >= 90 and value <= 100 then
        bat_icon = ' '
    elseif value >= 70 and value < 90 then
        bat_icon = ' '
    elseif value >= 60 and value < 70 then
        bat_icon = ' '
    elseif value >= 50 and value < 60 then
        bat_icon = ' '
    elseif value >= 30 and value < 50 then
        bat_icon = ' '
    elseif value >= 15 and value < 30 then
        bat_icon = ' '
    else
        bat_icon = ' '
    end

    battery_tooltip.markup =
    " " .. "<span foreground='" .. x.color12 .. "'>" .. bat_icon ..
    "</span>" .. value .. '% '
end)

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
-- Clock widget
-- ===================================================================
local timestring = wibox.widget.textclock("%H:%M%Z")
timestring.markup = timestring.text:sub(1, 2) .. "<span foreground='" .. x.color12 .. "'>" .. timestring.text:sub(3, 5) .. "</span>" .. "<span foreground='" .. x.color6 .. "'>" .. timestring.text:sub(6,8) .. "</span>"
timestring:connect_signal("widget::redraw_needed", function() timestring.markup = timestring.text:sub(1, 2) .. "<span foreground='" .. x.color12 .. "'>" .. timestring.text:sub(3, 5) ..  "</span>" .."<span foreground='" .. x.color6 .. "'>" .. timestring.text:sub(6,8) .. "</span>" end)
timestring.align = "center"
timestring.valign = "center"
local time = wibox.widget {
    markup = "-",
    align = 'center',
    valign = 'center',
    widget = timestring
}

local datestring = wibox.widget.textclock("%m-%d-%Y")
datestring.markup = datestring.text:sub(1, 3) .. "<span foreground='" .. x.color12 .. "'>" .. datestring.text:sub(4, 6) .. "</span>" .. "<span foreground='" .. x.color6 .. "'>" .. datestring.text:sub(7, 10) .. "</span>"
datestring:connect_signal("widget::redraw_needed", function() datestring.markup = datestring.text:sub(1, 3) .. "<span foreground='" .. x.color12 .. "'>" .. datestring.text:sub(4, 6) .. "</span>" .. "<span foreground='" .. x.color6 .. "'>" .. datestring.text:sub(7, 10) .. "</span>" end)
datestring.align = "center"
datestring.valign = "center"
local date = wibox.widget {
    markup = "-",
    align = 'center',
    valign = 'center',
    widget = datestring
}

local timedate_bar = wibox.widget{
    {
        {
            {
                {
                    date,
                    layout = wibox.layout.align.vertical
                },
                right = dpi(10),
                widget = wibox.container.margin
            },
            {
                {
                    time,
                    layout = wibox.layout.align.vertical
                },
                left = dpi(10),
                widget = wibox.container.margin
            },
            spacing = 1,
            spacing_widget = {
                bg = x.color8,
                widget = wibox.container.background
            },
            layout = wibox.layout.fixed.horizontal
        },
        top = dpi(2),
        left = dpi(10),
        right = dpi(10),
        widget = wibox.container.margin
    },
    bg = x.color0,
    shape = helpers.rrect(beautiful.border_radius - 3),
    widget = wibox.container.background
}

local calendar = lain.widget.cal({
        attach_to = {timedate_bar},
        notification_preset = {
            font = beautiful.font .. "10",
            fg = beautiful.fg_normal,
            bg = beautiful.bg_normal
        }
    })

-- ===================================================================
-- Create wibar
-- ===================================================================
screen.connect_signal("request::desktop_decoration", function(s)
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
        s.mywibox = awful.wibar({position = "top", screen = s, bg = beautiful.bg_normal .. 00})
        s.mywibox:set_xproperty("WM_NAME", "panel")

        -- Remove wibar on full screen
        local function remove_wibar(c)
            if c.fullscreen or c.maximized then
                c.screen.mywibox.visible = false
            else
                c.screen.mywibox.visible = true
            end
        end

        -- Hide bar when a splash widget is visible
        awesome.connect_signal("widgets::splash::visibility",
        function(vis) s.mywibox.visible = not vis end)

        client.connect_signal("property::fullscreen", remove_wibar)

        -- Create the taglist widget
        s.mytaglist = require("components.taglist")(s)

        -- Create a tasklist widget
        s.mytasklist = awful.widget.tasklist {
            screen = s,
            filter = awful.widget.tasklist.filter.currenttags,
            buttons = tasklist_buttons,
            bg = x.color0,
            style = {bg = x.color0},
            layout = {spacing = dpi(0), layout = wibox.layout.fixed.horizontal},
            widget_template = {
                {
                    {
                        nil,
                        awful.widget.clienticon,
                        nil,
                        layout = wibox.layout.fixed.horizontal
                    },
                    top = dpi(5),
                    bottom = dpi(5),
                    left = dpi(10),
                    right = dpi(10),
                    widget = wibox.container.margin
                },
                id = 'background_role',
                widget = wibox.container.background
            }
        }

        local final_systray = wibox.widget {
            {mysystray_container, top = dpi(5), layout = wibox.container.margin},
            bg = x.color0,
            shape = helpers.rrect(beautiful.border_radius - 3),
            widget = wibox.container.background
        }

        -- Add widgets to the wibox
        s.mywibox:setup{
            layout = wibox.layout.fixed.vertical,
            {
                widget = wibox.container.background,
                bg = x.color0,
                forced_height = dpi(1)
            },
            {
                layout = wibox.layout.align.horizontal,
                expand = "none",
                {
                    layout = wibox.layout.fixed.horizontal,
                    {
                        {
                            awesome_icon,
                            top = dpi(5),
                            right = dpi(10),
                            left = dpi(5),
                            bottom = dpi(5),
                            widget = wibox.container.margin
                        },
                        margin = dpi(5),
                        layout = wibox.container.margin
                    },
                    {
                        {
                            s.mytaglist,
                            bg = x.color0,
                            shape = helpers.rrect(beautiful.border_radius - 3),
                            widget = wibox.container.background
                        },
                        margins = dpi(5),
                        widget = wibox.container.margin
                    },
                    {
                        awful.widget.only_on_screen(playerctl_bar, screen[1]),
                        margins = dpi(5),
                        widget = wibox.container.margin
                    }
                },
                {
                    {
                        {
                            s.mytasklist,
                            bg = x.color0 .. "00",
                            shape = helpers.rrect(beautiful.border_radius - 3),
                            widget = wibox.container.background
                        },
                        margins = dpi(5),
                        widget = wibox.container.margin
                    },
                    widget = wibox.container.constraint
                },
                {
                    {
                        {
                            {
                                battery,
                                margins = dpi(5),
                                widget = wibox.container.margin
                            },
                            bg = x.color0,
                            shape = helpers.rrect(beautiful.border_radius - 3),
                            widget = wibox.container.background
                        },
                        margins = dpi(5),
                        widget = wibox.container.margin
                    },
                    nil,
                    nil,
                    {
                        awful.widget.only_on_screen(final_systray, screen[1]),
                        margins = dpi(5),
                        widget = wibox.container.margin
                    },
                    {
                        timedate_bar,
                        margins = dpi(5),
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
                            bg = x.color0,
                            shape = helpers.rrect(beautiful.border_radius - 3),
                            widget = wibox.container.background
                        },
                        margins = dpi(5),
                        widget = wibox.container.margin
                    },
                    layout = wibox.layout.fixed.horizontal
                }
            }
        }
    end)
