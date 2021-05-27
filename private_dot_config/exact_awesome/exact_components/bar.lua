-- bar.lua
local awful      = require("awful")
local gears      = require("gears")
local gfs        = require("gears.filesystem")
local wibox      = require("wibox")
local lain       = require("external.lain")
local beautiful  = require("beautiful")
local helpers    = require("helpers")
local markup     = lain.util.markup

local systray_margin = (beautiful.wibar_height - beautiful.systray_icon_size) / 2

-- helpers functions
local wrap_widget = function(w)
    local wrapped = wibox.widget {
        w,
        top = dpi(0),
        left = dpi(0),
        bottom = dpi(0),
        right = dpi(0),
        widget = wibox.container.margin
    }
    return wrapped
end


local make_pill = function(w, c)
    local pill = wibox.widget {
        w,
        bg = c or x.color0,
        widget = wibox.container.background
    }
    return pill
end


-- ===================================================================
--  Battery Bar Widget
-- ===================================================================

local battery_text = wibox.widget {
    font = beautiful.font,
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
}

local battery_icon = wibox.widget {
    font = beautiful.icon_font,
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
}

local battery_pill = wibox.widget {
    {
        {battery_icon, top = dpi(1), widget = wibox.container.margin},
        helpers.horizontal_pad(10),
        {battery_text, top = dpi(1), widget = wibox.container.margin},
        layout = wibox.layout.fixed.horizontal
    },
    left = dpi(10),
    right = dpi(10),
    widget = wibox.container.margin
}

awesome.connect_signal("daemon::battery", function(percentage, state)

    local value = percentage

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

     -- if charging
    if state == 1 then bat_icon = "" end

    -- if full
    if state == 4 then bat_icon = "" end

    battery_icon.markup = markup.fg.color(x.color12,bat_icon)
    battery_text.markup = markup.fg.color(x.color12, string.format("%1d", value)..'%')

end)

-- ===================================================================
-- Clock widget
-- ===================================================================
--
local date_text = wibox.widget {
    font = beautiful.font,
    format = "%m/%d/%y",
    align = "center",
    valign = "center",
    widget = wibox.widget.textclock
}

date_text.markup =markup.fg.color(x.color11, date_text.text)

date_text:connect_signal("widget::redraw_needed", function()
    date_text.markup = markup.fg.color(x.color11, date_text.text)
        right=dpi(7),
end)

local date_icon = wibox.widget {
    font = beautiful.font,
    markup = markup.fg.color(x.color11, " "),
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
}

local date_pill = wibox.widget {
    {
        {date_icon, top = dpi(1), widget = wibox.container.margin},
        helpers.horizontal_pad(10),
        {date_text, top = dpi(1), widget = wibox.container.margin},
        layout = wibox.layout.fixed.horizontal
    },
    left = dpi(10),
    right = dpi(10),
    widget = wibox.container.margin
}

local time_text = wibox.widget {
    font = beautiful.font,
    format = "%H:%M %ZGMT",
    align = "center",
    valign = "center",
    widget = wibox.widget.textclock
}

time_text.markup = markup.fg.color(x.color5, time_text.text)

time_text:connect_signal("widget::redraw_needed", function()
    time_text.markup = markup.fg.color(x.color5, time_text.text)
end)

local time_icon = wibox.widget {
    font = beautiful.font,
    markup = markup.fg.color(x.color5, " "),
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
}

local time_pill = wibox.widget {
    {
        {time_icon, top = dpi(1), widget = wibox.container.margin},
        helpers.horizontal_pad(10),
        {time_text, top = dpi(1), widget = wibox.container.margin},
        layout = wibox.layout.fixed.horizontal
    },
    left = dpi(10),
    right = dpi(10),
    widget = wibox.container.margin
}

local calendar = lain.widget.cal({
        attach_to = {date_pill},
        notification_preset = {
            font = beautiful.font .. "10",
            fg = beautiful.fg_normal,
            bg = beautiful.bg_normal
        }
    })

-- ===================================================================
-- Systray widgets
-- ===================================================================

local mysystray = wibox.widget.systray()
mysystray:set_base_size(beautiful.systray_icon_size)

local mysystray_container = {
    mysystray,
    right = dpi(12),
    left = dpi(12),
    widget = wibox.container.margin
}

local final_systray = wibox.widget {
    {
        mysystray_container,
        top=dpi(5),
        layout = wibox.container.margin
    },
    bg = x.color0,
    widget = wibox.container.background
}

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
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({theme = {width = 250}})
    end),
    awful.button({}, 4, function() awful.client.focus.byidx(1) end),
    awful.button({}, 5, function() awful.client.focus.byidx(-1) end)
    )


-- ===================================================================
-- Create wibar
-- ===================================================================
screen.connect_signal("request::desktop_decoration", function(s)
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    s.quake = lain.util.quake(
        {
            app = "termite",
            height = 0.43,
            width = 0.43,
            horiz = "center",
            followtag = true,
            argname = "--name %s"
        }
        )
    -- Create layoutbox widget
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
            awful.button({}, 1, function () awful.layout.set(awful.layout.layouts[10]) end),
            awful.button({}, 3, function () awful.layout.inc(-1) end),
            awful.button({}, 4, function () awful.layout.inc( 1) end),
        awful.button({}, 5, function () awful.layout.inc(-1) end))
        )
    if s.index == 1 then
        mysystray_container.visible = true
    else
        mysystray_container.visible = false
    end

    -- Create the wibox
    s.mywibox = awful.wibar({position = "top", screen = s, bg = beautiful.bg_normal.."85", type="dock"})
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
    awesome.connect_signal("widgets::splash::visibility", function(vis) s.mywibox.visible = not vis end)

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
                    {
                        awful.widget.clienticon,
                        top = dpi(3),
                        bottom = dpi(3),
                        right = dpi(3),
                        layout = wibox.container.margin
                    },
                    helpers.horizontal_pad(6),
                    {id = 'text_role', widget = wibox.widget.textbox},
                    layout = wibox.layout.fixed.horizontal
                },
                top = dpi(5),
                bottom = dpi(5),
                left = dpi(10),
                right = dpi(10),
                widget = wibox.container.margin
            },
            id = "background_role",
            widget = wibox.container.background
        }
    }

    -- Add widgets to the wibox
    s.mywibox:setup{
        layout = wibox.layout.fixed.vertical,
        nil,
        {
            {
                layout = wibox.layout.align.horizontal,
                expand = "none",
                {
                    layout = wibox.layout.fixed.horizontal,
                    wrap_widget(make_pill({
                        nil,
                        {
                            s.mytaglist,
                            helpers.horizontal_pad(4),
                            layout = wibox.layout.fixed.horizontal
                        },
                        spacing = 14,
                        layout = wibox.layout.fixed.horizontal
                    })),
                    s.mypromptbox,
                    nil,
                },
                {wrap_widget(s.mytasklist), widget=wibox.container.constraint},
                {
                    wrap_widget(awful.widget.only_on_screen(final_systray, screen[1])),
                    wrap_widget(make_pill(time_pill, x.color8 .. 00)),
                    wrap_widget(make_pill(date_pill, x.color8 .. 50)),
                    wrap_widget(make_pill(battery_pill, x.color8 .. 73)),
                    wrap_widget(make_pill({
                            s.mylayoutbox,
                            top = dpi(7),
                            bottom = dpi(7),
                            right = dpi(7),
                            left = dpi(7),
                            widget = wibox.container.margin
                        }, x.color8)),
                    layout = wibox.layout.fixed.horizontal
                }
            },
            widget = wibox.container.background,
            bg = x.color0
        },
        { -- This is for a bottom border in the bar
            widget = wibox.container.background,
            bg = x.color0,
            forced_height = 0
        }
    }
end)
