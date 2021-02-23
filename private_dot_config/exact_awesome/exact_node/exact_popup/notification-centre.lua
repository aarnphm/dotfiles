-- notification-centre.lua
-- Notification Popup Widget
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local popupLib = require("utils.popupLib")

local popupWidget = wibox.widget {
    {
        require("node.notification.notification-centre"),
        margins = dpi(8),
        widget = wibox.container.margin
    },
    expand = "none",
    layout = wibox.layout.fixed.horizontal
}

local width = 250

local popup = popupLib.create(awful.placement.top_right+awful.placement.no_offscreen, nil, width, popupWidget)

popup:set_xproperty("WM_NAME", "panel")

return popup

