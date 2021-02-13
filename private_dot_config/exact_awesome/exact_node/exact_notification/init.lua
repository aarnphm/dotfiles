local naughty   = require("naughty")
local beautiful = require("beautiful")
local gears     = require("gears")
local wibox     = require("wibox")
local awful     = require("awful")
local dpi       = beautiful.xresources.apply_dpi
local helpers   = require("helpers")


naughty.config.defaults.ontop               = true
naughty.config.defaults.screen              = awful.screen.focused()
naughty.config.defaults.border_color        = beautiful.widget_border_color
naughty.config.defaults.position            = "top_right"
naughty.config.defaults.shape               = helpers.rrect(beautiful.client_radius)
naughty.config.icon_dirs                    = {"/usr/share/icons/Papirus-Dark/24x24/apps/", "/usr/share/pixmaps/"}
naughty.config.icon_formats                 = {"png", "svg"}
naughty.config.defaults.border_width        = 1
naughty.config.defaults.timeout             = 2
naughty.config.defaults.notification_width  = 128
naughty.config.defaults.notification_height = 100
naughty.config.defaults.margin              = dpi(10)
naughty.config.defaults.icon_size           = dpi(32)
naughty.config.padding                      = dpi(3)
naughty.config.spacing                      = dpi(3)

-- Timeouts
naughty.config.presets.low.timeout          = 3
naughty.config.presets.critical.timeout     = 0

naughty.config.presets.normal = {
    font = beautiful.font,
    fg   = beautiful.fg_normal,
    bg   = beautiful.bg_normal
}

naughty.config.presets.low = {
    font = beautiful.font,
    fg   = beautiful.fg_normal,
    bg   = beautiful.bg_normal
}

naughty.config.presets.critical = {
    font    = beautiful.font_alt .. "10",
    fg      = beautiful.xcolor1,
    bg      = beautiful.bg_normal,
    timeout = 0
}

naughty.config.presets.ok   = naughty.config.presets.normal
naughty.config.presets.info = naughty.config.presets.normal
naughty.config.presets.warn = naughty.config.presets.critical
