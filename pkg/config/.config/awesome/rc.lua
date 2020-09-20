-- Standard awesome library
local root, awesome = root, awesome
local gears = require("gears")
local awful = require("awful")
local lain  = require("lain")
local wibox = require("wibox")
local markup = lain.util.markup
local apps = require("apps")
-- Import Tag Settings
local tags = require("tags")

-- Autofocus a new client when previously focused one is closed
require("awful.autofocus")

-- Import theme
local beautiful = require("beautiful")
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

-- Notification library
local naughty = require("naughty")

-- Define tag layouts
awful.util.tagnames = tags
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.corner.nw,
    awful.layout.suit.floating,
}

-- Import Keybinds
local keys = require("keys")
root.keys(keys.globalkeys)
root.buttons(keys.desktopbuttons)
awful.util.taglist_buttons = keys.taglist_buttons
awful.util.tasklist_buttons = keys.tasklist_buttons

-- Import rules
 
local create_rules = require("rules").create
awful.rules.rules = create_rules(keys.clientkeys, keys.clientbuttons)

local tyrannical = require("tyrannical")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- ===================================================================
-- Error handling
-- ===================================================================

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)

if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

run_once({ "unclutter -root","discord", "teams", "zoom",
            "kdocker -q -i /usr/share/icons/ePapirus/16x16/apps/spotify.svg spotify" }) -- entries must be comma-separated
-- @DOC_WALLPAPER@
local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- ===================================================================
-- Setup tyrannical
-- ===================================================================

-- First, set some settings
tyrannical.settings.default_layout =  awful.layout.suit.tile
tyrannical.settings.master_width_factor = 0.66

-- Setup some tags
tyrannical.tags = {
        {
        name        = tags[1],
        init        = true,
        exclusive   = true,
        screen      = {1,2},
        layout      = awful.layout.layouts[1],
        selected    = true,
        class       = {"xterm" , "urxvt" , "alacritty" ,"Code","termite"}
        },
        {
        name        = tags[2],
        init        = true,
        exclusive   = false,
        screen      = {1,2},
        selected    = true,
        layout      = awful.layout.layouts[2],
        class       = {"Firefox", "Chrome"}
        },
        {
        name = tags[3],
        init        = true,
        exclusive   = true,
        screen      = {1,2},
        selected    = true,
        layout      = awful.layout.layouts[3],
        class       = {"Spotify"},
        instance    = {"spotify"},
        },
        {
        name = tags[4],
        init        = true,
        exclusive   = false,
        screen      = {1,2},
        selected    = true,
        layout      = awful.layout.layouts[4],
        class       ={"Firefox", "Notion"},
        },
        {
        name        = tags[5],
        init        = true,
        screen      = {1,2},
        exclusive   = false,
        selected    = true,
        layout      = awful.layout.layouts[5],
        instance    = {"teams", "zoom", "skype"},
        },
        {
        name        = tags[6],
        init        = true,
        exclusive   = false,
        screen      = {1,2},
        selected    = true,
        layout      = awful.layout.layouts[6],
        instance    = {"steam", "discord"},
        }
}

-- Ignore the tag "exclusive" property for the following clients (matched by classes)
tyrannical.properties.intrusive = {"Feh","Nitrogen", "Arandr", "Nm-connection-editor","Blueman-manager", "Pavucontrol", "Pcmanfm", "Foxitreader"}

-- Ignore the tiled layout for the matching clients
tyrannical.properties.floating = {"feh"}

-- Make the matching clients (by classes) on top of the default layout
tyrannical.properties.ontop = {"rofi"}

-- ===================================================================
-- Set Up Screen & Connect Signals
-- ===================================================================

local spr = wibox.widget.textbox(" ")

-- Textclock
local clock = awful.widget.watch(
    "date +'%a %m-%d %R %Z'", 60,
    function(widget, stdout)
        widget:set_markup(" " .. markup.font(beautiful.font, stdout))
    end
)

-- Calendar
local cal = lain.widget.cal({
    attach_to = { clock },
    notification_preset = {
        font = beautiful.font,
        fg   = beautiful.fg_normal,
        bg   = beautiful.bg_normal
    }
})

-- Battery
local bat = lain.widget.bat({
    settings = function()
        if bat_now.status and bat_now.status ~= "N/A" then
            widget:set_markup(markup.font(beautiful.font, "Batt: " .. bat_now.perc .. "%"))
        else
            widget:set_markup(markup.font(beautiful.font, "Batt: AC"))
        end
    end
})

-- ALSA volume
local volume = lain.widget.alsa({
    settings = function()
        widget:set_markup(markup.font(beautiful.font, "Vol: " .. volume_now.level .. "%"))
    end
})
volume.widget:buttons(gears.table.join(
                               awful.button({}, 4, function ()
                                     awful.util.spawn("amixer set Master 1%+")
                                     volume.update()
                               end),
                               awful.button({}, 5, function ()
                                     awful.util.spawn("amixer set Master 1%-")
                                     volume.update()
                               end)
))

-- Net
local net = lain.widget.net({
    settings = function()
        widget:set_markup(markup.font(beautiful.font, "↓ " .. net_now.received .. " ↑ " .. net_now.sent .. ""))
    end
})

awful.screen.connect_for_each_screen(function(s)
    -- Tags, using tyranicall
    -- awful.tag(awful.util.tagnames, s, awful.layout.layouts)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
                           awful.button({ }, 3, function () awful.layout.inc(awful.layout.layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(awful.layout.layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(awful.layout.layouts, -1) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
            spr,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            spr,
            volume.widget,
            spr,
            bat.widget,
            spr,
            net,
            spr,
            clock,
            spr,
            s.mylayoutbox,
        },
    }
end)

-- No borders when rearranging only 1 non-floating or maximized client
screen.connect_signal("arrange", function (s)
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        if only_one and not c.floating or c.maximized then
            c.border_width = 0
        else
            c.border_width = beautiful.border_width
        end
    end
end
)

-- Signal function to execute when a new client appears.
-- @DOC_MANAGE_HOOK@
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- ===================================================================
-- Garbage collection (allows for lower memory consumption)
-- ===================================================================

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)

-- @DOC_BORDER@
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
