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
            border_width     = beautiful.border_width,
            border_color     = beautiful.border_normal,
            focus            = awful.client.focus.filter,
            raise            = true,
            size_hints_honor = true,
            honor_workarea   = true,
            placement        = awful.placement.no_overlap + awful.placement.no_offscreen
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
            class = {"Nm-connection-editor", "Cisco AnyConnect Secure Mobility Client",
                "gnome-disks", "caffeine", "Arandr", "Blueman-manager", "Nitrogen",
                "Nvidia-settings", "Baobab", "Xmessage", "Lxappearance", "Chatterino", 
                "Gparted", "Pavucontrol", "Qt5ct", "Kvantum", "Grub-customizer", "URxvt", "XTerm"},
            name  = {"Library", "Chat", "Event Tester", "Settings"},
            role  = {"Popup"},
            type  = {"dialog"}
        },
        properties = {floating = true}
    }

    -- ===================================================================
    -- Application specific rules
    -- ===================================================================
    ruled.client.append_rule {
        id = "spotify",
        rule = {class = "Spotify"},
        properties = {screen = screen.count()>1 and 2 or 1, tag = defaults.tags[1].names[4], switchtotag = true}
    }

    ruled.client.append_rule {
        id = "firefox",
        rule_any = {class = {"Firefox","Chromium"}},
        properties = {screen = screen.count()>1 and 2 or 1, tag = defaults.tags[1].names[2], switchtotag = true}
    }

    ruled.client.append_rule {
        id = "terminal",
        rule_any = {class = {"Alacritty", "St", "UXTerm", "XTerm"}},
        properties = {screen = screen.count()>1 and 2 or 1, tag = defaults.tags[1].names[1], switchtotag = true}
    }

    ruled.client.append_rule {
        id = "steam",
        rule = {class = "Steam"},
        properties = {screen = screen.count()>1 and 2 or 1, tag = defaults.tags[1].names[5], switchtotag = true}
    }

    ruled.client.append_rule {
        id = "kitty",
        rule = {class = "kitty"},
        properties = {screen = 1, tag = defaults.tags[1].names[1], switchtotag = true}
    }

    ruled.client.append_rule {
        id = "termite",
        rule = {class = "Termite"},
        properties = {ontop=true, screen = awful.screen.focused(), switchtotag = true}
    }

    ruled.client.append_rule {
        id = "vmware",
        rule = {class = "vmware"},
        properties = {screen = screen.count()>1 and 2 or 1, tag=defaults.tags[1].names[2], switchtotag = true}
    }

    ruled.client.append_rule {
        id = "meeting",
        rule_any = {class={"Whatsapp-for-linux"}, instance = {"discord", "slack", "skype","caprine"}},
        properties = {screen = screen.count()>1 and 3 or 1, tag = defaults.tags[1].names[5], switchtotag = true}
    }

    ruled.client.append_rule {
        id = "zooms",
        rule_any = {class={"Zoom", "Microsoft Teams - Preview"}},
        properties = {screen = screen.count()>1 and 2 or 1, tags = defaults.tags[1].names[5], switchtotag=true}
    }

    ruled.client.append_rule{
        id = "gimp",
        rule = {class = "Gimp"},
        properties = {maximized = true, tag=defaults.tags[1].names[2], switchtotag=true}
    }

    ruled.client.append_rule{
        id = "obs",
        rule = {class = "obs"},
        properties = {screen=screen.count()>1 and 3 or 1, tag=defaults.tags[1].names[2], switchtotag=true}
    }
    -- Rofi
    ruled.client.append_rule{
        id = "rofi",
        rule = {instance = "rofi"},
        properties = {maximized = false, ontop = true},
    }
    -- File chooser dialog
    ruled.client.append_rule{
        id = "chooser_dialog",
        rule_any = {role = "GtkFileChooserDialog"},
        properties = {floating = true, width = defaults.screen_width * 0.55, height = defaults.screen_height * 0.65}
    }
end)
