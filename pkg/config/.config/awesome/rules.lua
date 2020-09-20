local awful = require("awful")
local beautiful = require("beautiful")

local screen_height = awful.screen.focused().geometry.height
local screen_width = awful.screen.focused().geometry.width

-- define module table
local rules = {}

-- ===================================================================
-- Rules
-- ===================================================================


function rules.create(clientkeys, clientbuttons)
    return
    {
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
               "nvidia-settings"
            },
            class = {
               "Nm-connection-editor",
               "Arandr",
               "Blueman-manager",
               "Pavucontrol",
               "Pcmanfm",
               "Nitrogen",
               "Termite"
            },
            name = {
                "Library"
            },
            type = {
               "dialog"
            }}, properties = {floating = true}
    },
    { rule = { class = "Gimp" }, properties = { maximized = true } },
    -- Rofi
    { rule_any = { instance = { "rofi" } }, properties = { maximized = false, ontop = true } },
    -- File chooser dialog
    {rule_any = {role = "GtkFileChooserDialog"}, properties = {floating = true, width = screen_width * 0.55, height = screen_height * 0.65}},
    }
end

-- return module table
return rules
