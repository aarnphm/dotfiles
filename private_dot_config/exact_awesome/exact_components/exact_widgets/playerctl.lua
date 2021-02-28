local gears      = require("gears")
local awful      = require("awful")
local wibox      = require("wibox")
local helpers    = require("helpers")
local beautiful  = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi        = xresources.apply_dpi

local create_button = function(symbol, color, command, playpause)

    local icon = wibox.widget {
        markup = helpers.colorize_text(symbol, color),
        font = beautiful.fontname .. " 20",
        align = "center",
        valigin = "center",
        widget = wibox.widget.textbox()
    }

    local button = wibox.widget {
        icon,
        forced_height = dpi(30),
        forced_width = dpi(30),
        widget = wibox.container.background
    }

    awesome.connect_signal("daemon::spotify", function(_,_,playing)
        if playpause then
            if playing then
                icon.markup = helpers.colorize_text("", color)
            else
                icon.markup = helpers.colorize_text("", color)
            end
        end
    end)

    button:buttons(gears.table.join(
                       awful.button({}, 1, function() command() end)))

    button:connect_signal("mouse::enter", function()
        icon.markup = helpers.colorize_text(icon.text, beautiful.xforeground)
    end)

    button:connect_signal("mouse::leave", function()
        icon.markup = helpers.colorize_text(icon.text, color)
    end)

    return button
end

local title_widget = wibox.widget {
    markup = '-----',
    align = 'center',
    valign = 'center',
    ellipsize = 'middle',
    widget = wibox.widget.textbox
}

local artist_widget = wibox.widget {
    markup = '-----',
    align = 'center',
    valign = 'center',
    ellipsize = 'middle',
    wrap = 'word_char',
    widget = wibox.widget.textbox
}

-- Get Song Info 
awesome.connect_signal("daemon::spotify", function(artist, title,_)
    title_widget:set_markup_silently(
        '<span foreground="' .. beautiful.xcolor5 .. '">' .. title .. '</span>')
    artist_widget:set_markup_silently(
        '<span foreground="' .. beautiful.xcolor6 .. '">' .. artist .. '</span>')
end)

local play_command =
    function() awful.spawn.with_shell("playerctl play-pause") end
local prev_command = function() awful.spawn.with_shell("playerctl previous") end
local next_command = function() awful.spawn.with_shell("playerctl next") end

local playerctl_play_symbol = create_button("", beautiful.xcolor4,
                                            play_command, true)

local playerctl_prev_symbol = create_button("玲", beautiful.xcolor4,
                                            prev_command, false)
local playerctl_next_symbol = create_button("怜", beautiful.xcolor4,
                                            next_command, false)

local playerctl = wibox.widget {
    {
        nil,
        left = dpi(22),
        top = dpi(17),
        bottom = dpi(17),
        layout = wibox.container.margin
    },
    {
        {
            {
                {
                    title_widget,
                    artist_widget,
                    layout= wibox.layout.fixed.vertical
                },
                top = 10,
                left = 25,
                right = 25,
                widget = wibox.container.margin
            },
            {
                nil,
                {
                    playerctl_prev_symbol,
                    playerctl_play_symbol,
                    playerctl_next_symbol,
                    spacing = dpi(40),
                    layout = wibox.layout.fixed.horizontal
                },
                nil,
                expand = "none",
                layout = wibox.layout.align.horizontal
            },
            layout = wibox.layout.align.vertical
        },
        top = dpi(0),
        bottom = dpi(10),
        widget = wibox.container.margin
    },
    layout = wibox.layout.align.horizontal
}

return playerctl
