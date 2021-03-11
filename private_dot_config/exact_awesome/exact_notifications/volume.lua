local naughty       = require("naughty")

local notif
local timeout = 1.5
local first_time = true
awesome.connect_signal("components::volume", function (percentage, muted)
    if first_time then
        first_time = false
    else
        if (client.focus and client.focus.class == "Pavucontrol") then
            -- Sidebar and Pavucontrol already show volume, so
            -- destroy notification if it exists
            if notif then
                notif:destroy()
            end
        else
            -- Send notification
            local message, icon
            if muted then
                message = "muted"
                icon = "ﳌ"
            else
                message = tostring(percentage)
                icon = ""
            end

            notif = notify_dwim({ title = "Volume", message = message, icon = icon, timeout = timeout, app_name = "volume" }, notif)
        end
    end
end)

