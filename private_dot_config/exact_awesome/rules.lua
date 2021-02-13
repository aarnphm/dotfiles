local awful     = require("awful")
local beautiful = require("beautiful")
local def       = require("defaults")

-- ===================================================================
-- Define sets rules
-- ===================================================================
rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            -- placement can also + awful.placement.no_overlap + awful.placement.no_offscreen
            placement = awful.placement.centered
        }
    },
    {
        rule_any = {
            class = {"Nm-connection-editor", "Gnome-disks", "caffeine", "Arandr", "Zotero", "Blueman-manager",
                     "Nitrogen", "Nvidia-settings", "Baobab", "Xmessage", "Skype", "Lxappearance", "Chatterino",
                     "Zoom", "Gparted", "Pavucontrol", "Qt5ct", "Kvantum", "Grub-customizer"},
            name  = {"Library", "Chat", "Event Tester", "Settings"},
            role  = {"pop-up"},
            type  = {"dialog"}
        },
        properties = {floating = true}
    },
    {
        rule = {class = "Spotify"},
        properties = {screen = screen.count()>1 and 2 or 1, tag = "4", switchtotag = true}
    },
    {
        rule = {class = "Kitty"},
        properties = {screen = screen.count()>1 and 2 or 1, tag = "1", switchtotag = true}
    },
    {
        rule_any = {instance={"chromium","firefox"}},
        properties = {tag = "3", switchtotag = true}
    },
    {
        rule_any = {class="Microsoft Teams - Preview", instance = {"zoom", "discord", "slack", "skype","caprine"}},
        properties = {screen=screen.count()>1 and 2 or 1, tag="5", switchtotag = true}
    },
    {rule = {class = "Gimp"}, properties = {maximized = true}},
    -- Rofi
    {rule = {instance = "rofi"}, properties = {maximized = false, ontop = true}},
    -- other terminal
    {rule_any = {instance = {"termite","alacritty"}}, properties = {maximized = false, ontop = true, floating = true}},
    -- File chooser dialog
    {
        rule_any = {role = "GtkFileChooserDialog"},
        properties = {floating = true, width = def.screen_width * 0.55, height = def.screen_height * 0.65}
    }
}

return rules
