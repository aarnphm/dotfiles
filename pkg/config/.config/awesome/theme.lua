-- ===================================================================
-- Initialization
-- ===================================================================
local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi

local markup = lain.util.markup
local os = os

-- define module table
local theme = {}

-- ===================================================================
-- Theme Variables
-- ===================================================================

local theme                                     = {}
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome"
theme.icon_theme                                = "ePapirus"
theme.font                                      = "InconsolataGo Nerd Font 9"
theme.fg_normal                                 = "#FEFEFE"
theme.fg_focus                                  = "#EA6F81"
theme.fg_urgent                                 = "#CC9393"
theme.bg_normal                                 = "#000000"
theme.bg_focus                                  = "#313131"
theme.bg_urgent                                 = "#1A1A1A"
theme.border_width                              = dpi(1)
theme.border_normal                             = "#3F3F3F"
theme.border_focus                              = "#7F7F7F"
theme.border_marked                             = "#CC9393"
theme.tasklist_bg_focus                         = theme.bg_normal
theme.titlebar_bg_focus                         = theme.bg_focus
theme.titlebar_bg_normal                        = theme.bg_normal
theme.titlebar_fg_focus                         = theme.fg_focus
theme.menu_height                               = dpi(16)
theme.menu_width                                = dpi(140)
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = true
theme.useless_gap                               = dpi(5)

-- ===================================================================
-- Icons
-- ===================================================================

-- theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"
theme.taglist_squares_sel                       = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"
-- theme.layout_fairv                              = theme.dir .. "/icons/fairv.png"
-- theme.layout_fairh                              = theme.dir .. "/icons/fairh.png"
-- theme.layout_spiral                             = theme.dir .. "/icons/spiral.png"
theme.layout_dwindle                            = theme.dir .. "/icons/layouts/dwindle.svg"
-- theme.layout_magnifier                          = theme.dir .. "/icons/magnifier.png"

-- testing theme
theme.layout_tile                               = theme.dir .. "/icons/layouts/tile.svg"
theme.layout_floating                           = theme.dir .. "/icons/layouts/floating.svg"
theme.layout_max                                = theme.dir .. "/icons/layouts/max.png"
-- theme.layout_max                                = theme.dir .. "/icons/layouts/fullscreen.svg"


-- ===================================================================
-- Bar Creation
-- ===================================================================

-- wibox separator
local spr = wibox.widget.textbox(" ")

-- Textclock
local clock = awful.widget.watch(
    "date +'%a %m-%d %R %Z'", 60,
    function(widget, stdout)
        widget:set_markup(" " .. markup.font(theme.font, stdout))
    end
)

-- Calendar
theme.cal = lain.widget.cal({
    attach_to = { clock },
    notification_preset = {
        font = theme.font,
        fg   = theme.fg_normal,
        bg   = theme.bg_normal
    }
})

-- Battery
local bat = lain.widget.bat({
    settings = function()
        if bat_now.status and bat_now.status ~= "N/A" then
            widget:set_markup(markup.font(theme.font, "Batt: " .. bat_now.perc .. "% "))
        else
            widget:set_markup(markup.font(theme.font, "Batt: AC "))
        end
    end
})

-- ALSA volume
theme.volume = lain.widget.alsa({
    settings = function()
        widget:set_markup(markup.font(theme.font, "Vol: " .. volume_now.level .. "% "))
    end
})
theme.volume.widget:buttons(awful.util.table.join(
                               awful.button({}, 4, function ()
                                     awful.util.spawn("amixer set Master 1%+")
                                     theme.volume.update()
                               end),
                               awful.button({}, 5, function ()
                                     awful.util.spawn("amixer set Master 1%-")
                                     theme.volume.update()
                               end)
))

-- Net
local net = lain.widget.net({
    settings = function()
        widget:set_markup(markup.font(theme.font, " ↓ " .. net_now.received .. " ↑ " .. net_now.sent .. " "))
    end
})

function theme.at_screen_connect(s)
    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts)

    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({}, 1, function () awful.layout.inc( 1) end),
                           awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
                           awful.button({}, 3, function () awful.layout.inc(-1) end),
                           awful.button({}, 4, function () awful.layout.inc( 1) end),
                           awful.button({}, 5, function () awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = theme.menu_height, bg = theme.bg_normal, fg = theme.fg_normal })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            spr,
        },
        {
        layout = wibox.layout.fixed.horizontal,
        s.mypromptbox,
        s.mytasklist, -- Middle widget
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            spr,
            theme.volume.widget,
            bat.widget,
            net,
            clock,
            s.mylayoutbox,
        },
    }
end

return theme
