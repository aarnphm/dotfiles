local wibox = require("wibox")
local beautiful = require("beautiful")

local helpers = require("helpers")

local weather_heading = wibox.widget({
    align = "center",
    valign = "center",
    font = beautiful.fontname .. "15",
    markup = helpers.colorize_text("--wttr.in--", beautiful.xcolor4),
    widget = wibox.widget.textbox()
})

-- currently wttr.in is out of quotes, just use a default weather for now
-- awesome.connect_signal("components::weather", function(temp, wind, emoji)
--     weather_heading.markup = helpers.colorize_text(emoji .. "  " .. tostring(temp) .. "°C in " .. beautiful.weather_city, beautiful.xcolor4)
-- end)

return weather_heading
