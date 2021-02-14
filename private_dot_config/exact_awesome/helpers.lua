-- helpers.lua

local awful      = require("awful")
local gears      = require("gears")
local beautiful  = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi        = xresources.apply_dpi
local wibox      = require("wibox")
local naughty    = require("naughty")

local helpers = {}

-- Create rounded rectangle shape (in one line)

helpers.rrect = function(radius)
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, radius)
    end
end

return helpers
