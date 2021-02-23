local beautiful = require("beautiful")
local wibox = require('wibox')

local dpi = require('beautiful').xresources.apply_dpi

local empty_notifbox = wibox.widget {
    {
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(5),
        {
            expand = 'none',
            layout = wibox.layout.align.horizontal,
            nil,
            {
                image = beautiful.notification_none_icon,
                forced_height = dpi(20),
                forced_width = dpi(20),
                resize = true,
                widget = wibox.widget.imagebox
            },
            nil
        },
        {
            markup = 'No new notification !',
            font = beautiful.fontname .. '10',
            align = 'center',
            valign = 'center',
            widget = wibox.widget.textbox
        }
    },
    margins = dpi(20),
    widget = wibox.container.margin

}

local centered_empty_notifbox = wibox.widget {
    layout = wibox.layout.fixed.vertical,
    expand = 'none',
    empty_notifbox
}

return centered_empty_notifbox
