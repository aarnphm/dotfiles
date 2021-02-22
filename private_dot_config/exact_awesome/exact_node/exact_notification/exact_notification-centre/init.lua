local wibox = require('wibox')
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local notif_header = wibox.widget {
    markup = 'Notifications',
    font = "mononoki Nerd Font 12",
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

return wibox.widget {
    {
        notif_header,
        nil,
        require("node.notification.notification-centre.clear-all"),
        expand = "none",
        spacing = dpi(10),
        layout = wibox.layout.align.horizontal
    },
    require('node.notification.notification-centre.build-notifbox'),

    spacing = dpi(10),
    layout = wibox.layout.fixed.vertical
}
