local awful     = require("awful")
local beautiful = require("beautiful")
local defaults  = require("defaults")
-- updates to newer api
local ruled     = require("ruled")

-- ===================================================================
-- Define sets rules
-- ===================================================================

ruled.client.connect_signal("request::rules", function()

    -- ===================================================================
    -- Global
    -- ===================================================================
    ruled.client.append_rule{
        id         = "global",
        rule       = {},
        properties = {
            focus            = awful.client.focus,
            raise            = true,
            size_hints_honor = false,
            screen           = awful.screen.preferred,
            placement        = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen
            -- placement can also + awful.placement.no_overlap + awful.placement.no_offscreen
        }
    }

    -- ===================================================================
    -- Tasklist order
    -- ===================================================================
    ruled.client.append_rule{
        id         = "tasklist_order",
        rule       = {},
        properties = {},
        callback   = awful.client.setslave
    }

    -- ===================================================================
    -- Float clients
    -- ===================================================================
    ruled.client.append_rule{
        id         = "floating",
        rule_any   = {
            class = {"Nm-connection-editor", "caffeine", "Arandr", "Blueman-manager", "Nitrogen", "Nvidia-settings", 
                     "Baobab", "Xmessage", "Lxappearance", "Chatterino", "Zoom", "Gparted", "Pavucontrol", "Qt5ct",
                     "Kvantum", "Grub-customizer","Xscreensaver-Demo"},
            name  = {"Library", "Chat", "Event Tester", "Settings"},
            role  = {"pop-up"},
            type  = {"dialog"}
        },
        properties = {floating = true}
    }

    -- ===================================================================
    -- Borders
    -- ===================================================================
    ruled.client.append_rule {
        id = "borders",
        rule_any = {type = {"normal", "dialog"}},
        except_any = {
            role = {"Popup"},
            type = {"splash"},
            name = {"^discord.com is sharing your screen.$"}
        },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal
        }
    }

    -- ===================================================================
    -- Application specific rules
    -- ===================================================================
    ruled.client.append_rule {
        rule = {class = "Spotify"},
        properties = {screen = screen.count()>1 and 2 or 1, tag = defaults.tags[1].names[4], switchtotag = true}
    }

    ruled.client.append_rule {
        rule = {class = "Kitty"},
        properties = {screen = screen.count()>1 and 2 or 1, tag = defaults.tags[1].names[1], switchtotag = true}
    }

    ruled.client.append_rule {
        rule_any = {class = {"Alacritty", "Termite", "Kitty", "St", "UXTerm", "XTerm"}},
        properties = {tag = defaults.tags[1].names[1], switchtotag = true}
    }
    ruled.client.append_rule{rule = {class = "Termite"}, properties = {maximized = false, ontop = true, floating = true}}

    ruled.client.append_rule {
        rule_any = {instance={"chromium","firefox"}},
        properties = {tag = defaults.tags[1].names[3], switchtotag = true}
    }

    ruled.client.append_rule {
        rule_any = {class="Microsoft Teams - Preview", instance = {"zoom", "discord", "slack", "skype","caprine"}},
        properties = {screen=screen.count()>1 and 2 or 1, tag = defaults.tags[1].names[5], switchtotag = true}
    }

    ruled.client.append_rule{
        rule = {class = "Gimp"}, properties = {maximized = true, tag=defaults.tags[1].names[2], switchtotag=true}
    }

    ruled.client.append_rule{
        rule = {class = "obs"}, properties = {screen=screen.count()>1 and 2 or 1, tag=defaults.tags[1].names[2], switchtotag=true}
    }
    -- Rofi
    ruled.client.append_rule{rule = {instance = "rofi"}, properties = {maximized = false, ontop = true}}
    -- File chooser dialog
    ruled.client.append_rule{
        rule_any = {role = "GtkFileChooserDialog"},
        properties = {floating = true, width = defaults.screen_width * 0.55, height = defaults.screen_height * 0.65}
    }

end)
