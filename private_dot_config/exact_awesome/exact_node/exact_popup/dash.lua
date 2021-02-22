local awful      = require("awful")
local gears      = require("gears")
local wibox      = require("wibox")
local beautiful  = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi        = xresources.apply_dpi
local helpers    = require("helpers")
local default    = require("defaults")

local popupLib   = require("utils.popupLib")


local box_radius = beautiful.client_radius
local box_gap = dpi(8)

local function create_boxed_widget(widget_to_be_boxed, width, height, bg_color)
    local box_container = wibox.container.background()
    box_container.bg = bg_color
    box_container.forced_height = height
    box_container.forced_width = width
    box_container.shape = helpers.rrect(box_radius)

    local boxed_widget = wibox.widget {
        {
            {
                nil,
                {
                    nil,
                    widget_to_be_boxed,
                    layout = wibox.layout.align.vertical,
                    expand = "none"
                },
                layout = wibox.layout.align.horizontal
            },
            widget = box_container
        },
        margins = box_gap,
        color = "#FF000000",
        widget = wibox.container.margin
    }
    return boxed_widget
end

-- Helper function that changes the appearance of progress bars and their icons
-- Create horizontal rounded bars
local function format_progress_bar(bar, markup)
    local text = wibox.widget {
        markup = markup,
        align  = 'center',
        valign = 'center',
        font   = 'mononoki Nerd Font 12',
        widget = wibox.widget.textbox
    }
    text.forced_height = dpi(36)
    text.forced_width  = dpi(36)
    text.resize        = true

    local w = wibox.widget {text, bar, layout = wibox.layout.stack}
    return w
end

--- {{{ Volume Widget

local volume_bar = require("node.widgets.volume_arc")
local volume = format_progress_bar(volume_bar, "<span foreground='" .. beautiful.xcolor6 .. "'><b></b></span>")

awesome.connect_signal("components::volume", function(vol, muted)
    if muted or vol == 0 then
        volume.children[1].markup = "<span foreground='" .. beautiful.xcolor6 .. "'><b></b></span>"
    else
        if vol > 50 then
            volume.children[1].markup = "<span foreground='" .. beautiful.xcolor6 .. "'><b></b></span>"
        else
            volume.children[1].markup = "<span foreground='" .. beautiful.xcolor6 .. "'><b></b></span>"
        end
    end
end)

volume:buttons(gears.table.join( -- Left click - Mute / Unmute
        awful.button({}, 1, function() helpers.volume_control(0) end),
        awful.button({}, 2, function() awful.spawn("pavucontrol") end),
        -- Scroll - Increase / Decrease volume
        awful.button({}, 4, function() helpers.volume_control(5) end),
    awful.button({}, 5, function() helpers.volume_control(-5) end))
    )

--- {{{ Brightness Widget

local brightness_bar = require("node.widgets.brightness_arc")
local brightness = format_progress_bar(brightness_bar, "<span foreground='"..beautiful.xcolor5.."'><b></b></span>")

--- }}}

--- {{{ Ram Widget

-- local ram = require("node.widgets.ram_arc")

local ram_bar = require("node.widgets.ram_arc")
local ram = format_progress_bar(ram_bar, "<span foreground='"..beautiful.xcolor3 .."'><b></b></span>")

--- }}}

--- {{{ Disk Widget

local disk_bar = require("node.widgets.disk_arc")
local disk = format_progress_bar(disk_bar, "<span foreground='"..beautiful.xcolor2.."'><b></b></span>")

--- }}}

--- {{{ Temp Widget

local temp_bar = require("node.widgets.temp_arc")
local temp = format_progress_bar(temp_bar, "<span foreground='"..beautiful.xcolor1.."'><b></b></span>")

--- }}}

--- {{{ Cpu Widget

-- local cpu = require("node.widgets.cpu_arc")

local cpu_bar = require("node.widgets.cpu_arc")
local cpu = format_progress_bar(cpu_bar, "<span foreground='"..beautiful.xcolor4.."'><b></b></span>")

--- }}}

--- {{{ Clock

local fancy_time_widget = wibox.widget.textclock("%H:%M")
fancy_time_widget.markup = fancy_time_widget.text:sub(1, 2) .. "<span foreground='" .. beautiful.xcolor12 .. "'>" .. fancy_time_widget.text:sub(3, 5) .. "</span>"
fancy_time_widget:connect_signal("widget::redraw_needed", function() fancy_time_widget.markup = fancy_time_widget.text:sub(1, 2) .. "<span foreground='" .. beautiful.xcolor12 .. "'>" .. fancy_time_widget.text:sub(3, 5) .. "</span>" end)
fancy_time_widget.align = "center"
fancy_time_widget.valign = "center"
fancy_time_widget.font =  "mononoki Nerd Font 55"

local fancy_time = {fancy_time_widget, layout = wibox.layout.fixed.vertical}

local fancy_date_widget = wibox.widget.textclock("%m-%d-%Y")
fancy_date_widget.markup = fancy_date_widget.text:sub(1, 3) .. "<span foreground='" .. beautiful.xcolor12 .. "'>" .. fancy_date_widget.text:sub(4, 6) .. "</span>" .. "<span foreground='" .. beautiful.xcolor6 .. "'>" .. fancy_date_widget.text:sub(7, 10) .. "</span>"
fancy_date_widget:connect_signal("widget::redraw_needed", function() fancy_date_widget.markup = fancy_date_widget.text:sub(1, 3) .. "<span foreground='" .. beautiful.xcolor12 .. "'>" .. fancy_date_widget.text:sub(4, 6) .. "</span>" .. "<span foreground='" .. beautiful.xcolor6 .. "'>" .. fancy_date_widget.text:sub(7, 10) .. "</span>" end)
fancy_date_widget.align = "center"
fancy_date_widget.valign = "center"
fancy_date_widget.font =  "mononoki Nerd Font 12"

local fancy_date = {fancy_date_widget, layout = wibox.layout.fixed.vertical}

---}}}


local playerctl = require("node.widgets.playerctl")
local playerctl_box = create_boxed_widget(playerctl, 400, 125, beautiful.xcolor0)

-- {{{ Info Widget

local info = require("node.widgets.info")
local info_box = create_boxed_widget(info, 400, 125, beautiful.xbackground)

-- }}}

-- {{ Weather

local weather = require("node.widgets.weather")
local weather_box = create_boxed_widget(weather, 400, 125, beautiful.xcolor0)

-- }}


local sys = wibox.widget {
    {
        cpu,
        top = dpi(20),
        bottom = dpi(0),
        left = dpi(0),
        right = dpi(0),
        widget = wibox.container.margin
    },
    {
        {
            volume,
            top = dpi(0),
            bottom = dpi(20),
            left = dpi(0),
            right = dpi(0),
            widget = wibox.container.margin
        },
        {
            brightness,
            top = dpi(0),
            bottom = dpi(20),
            left = dpi(0),
            right = dpi(0),
            widget = wibox.container.margin
        },
        layout = wibox.layout.flex.horizontal
    },
    spacing = dpi(0),
    layout = wibox.layout.flex.vertical
}

local sys2 = wibox.widget {
    {
        ram,
        top = dpi(20),
        bottom = dpi(0),
        left = dpi(0),
        right = dpi(0),
        widget = wibox.container.margin
    },
    {
        {
            disk,
            top = dpi(0),
            bottom = dpi(20),
            left = dpi(0),
            right = dpi(0),
            widget = wibox.container.margin
        },
        {
            temp,
            top = dpi(0),
            bottom = dpi(20),
            left = dpi(0),
            right = dpi(0),
            widget = wibox.container.margin
        },
        layout = wibox.layout.flex.horizontal
    },
    spacing = dpi(0),
    layout = wibox.layout.flex.vertical
}

-- local sys2 = wibox.widget {ram, disk, temp, layout = wibox.layout.flex.vertical}

local sys_box = create_boxed_widget(sys, 400, 200, beautiful.xcolor0)
local sys_box2 = create_boxed_widget(sys2, 400, 200, beautiful.xcolor0)

local time = wibox.widget {
    {fancy_time, fancy_date, layout = wibox.layout.align.vertical},
    top = dpi(0),
    left = dpi(20),
    right = dpi(20),
    bottom = dpi(10),
    widget = wibox.container.margin
}

local time_box = create_boxed_widget(time, 400, 159, beautiful.xcolor0)

local panelWidget = wibox.widget {
    {weather_box, sys_box, layout = wibox.layout.align.vertical},
    {info_box, time_box, layout = wibox.layout.align.vertical},
    {playerctl_box, sys_box2, layout = wibox.layout.align.vertical},
    layout = wibox.layout.flex.horizontal
}

local dash_manager = {}
local dashboard = wibox({visible = false, ontop = true, type = "splash"})
awful.placement.maximize(dashboard)

dashboard.bg = beautiful.exit_screen_bg or "#111111"
dashboard.fg = beautiful.exit_screen_fg or "#FEFEFE"

local dash_grabber

dash_manager.dash_hide = function()
    awful.keygrabber.stop(dash_grabber)
    dashboard.visible = false
    awesome.emit_signal("widgets::splash::visibility", dashboard.visible)
end

dash_manager.dash_show = function()
    dash_grabber = awful.keygrabber.run(function(_, key, event)
        -- Ignore case
        key = key:lower()
        if event == "release" then return end
        if key == 'escape' or key == 'q' or key == 'x' then
            dash_manager.dash_hide()
        end
    end)
    dashboard.visible = true
    awesome.emit_signal("widgets::splash::visibility", dashboard.visible)
end

dashboard:setup{
    nil,
    {nil, panelWidget, expand = "none", layout = wibox.layout.align.horizontal},
    expand = "none",
    layout = wibox.layout.align.vertical
}

return dash_manager
