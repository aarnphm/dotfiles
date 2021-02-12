local naughty = require("naughty")
local icons = require('icons')
icons.init("def")

local display = true

awesome.connect_signal("components::battery", function(value)
    if value < 11 then
        naughty.notify({
            title = "Battery Status",
            text = "Running low at " .. value .. "%",
            image = icons.battery
        })
    end

    if (value > 94 and display) then
        naughty.notify({
            title = "Battery Status",
            text = "Running high at " .. value .. "%",
            image = icons.battery
        })
        display = false
    end
end)

awesome.connect_signal("components::charger", function(plugged)
    if plugged then
        naughty.notify({
            title = "Battery Status",
            text = "Charging",
            image = icons.battery_charging
        })
        display = true
    end

end)
