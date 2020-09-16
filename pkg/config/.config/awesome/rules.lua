local awful = require("awful")
local beautiful = require("beautiful")

local screen_height = awful.screen.focused().geometry.height
local screen_width = awful.screen.focused().geometry.width
--local dpi = beautiful.xresources.apply_dpi

-- define module table
local rules = {}

-- ===================================================================
-- Rules
-- ===================================================================


function rules.create(clientkeys, clientbuttons)
    return {
        -- All clients will match this rule.
    {
         rule = {},
         properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen,
            size_hints_honor = false
         },
      },
        -- Floating clients.
     {
         rule_any = {
            instance = {
               "DTA",
               "copyq",
            },
            class = {
               "Nm-connection-editor",
               "Arandr",
               "Blueman-manager",
               "Pcmanfm",
            },
            name = {
               "Event Tester",
               "Steam Guard - Computer Authorization Required"
            },
            role = {
               "pop-up",
               "GtkFileChooserDialog"
            },
            type = {
               "dialog"
            }
         }, properties = {floating = true}
      },

        -- Rofi
        {
        rule_any = { name = { "rofi" } },
        properties = { maximized = false, ontop = true }
        },

        -- File chooser dialog
        {
        rule_any = { role = { "GtkFileChooserDialog" } },
        properties = { floating = true, width = screen_width * 0.35, height = screen_height * 0.65 }
        },

        -- Pavucontrol & Bluetooth Devices
        {
        rule_any = { class = { "Pavucontrol" }, name = { "Bluetooth Devices" } },
        properties = { floating = true, width = screen_width * 0.55, height = screen_height * 0.45 }
        },
    }
end

-- return module table
return rules
