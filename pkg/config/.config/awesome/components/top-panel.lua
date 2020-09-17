-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local lain  = require("lain")
local dpi = beautiful.xresources.apply_dpi
local markup = lain.util.markup

-- define module table
local top_panel = {}


-- ===================================================================
-- Bar Creation
-- ===================================================================

-- ALSA volume
local volume = lain.widget.alsa({
    settings = function()
        widget:set_markup(markup.font(theme.font, " Vol: " .. volume_now.level .. "% "))
    end
})
volume.widget:buttons(awful.util.table.join(
                               awful.button({}, 4, function ()
                                     awful.util.spawn("amixer set Master 1%+")
                                     theme.volume.update()
                               end),
                               awful.button({}, 5, function ()
                                     awful.util.spawn("amixer set Master 1%-")
                                     theme.volume.update()
                               end)
))

-- Clock
local clock = awful.widget.watch(
    "date +'%a %m-%d %R %Z'", 60,
    function(widget, stdout)
        widget:set_markup(" " .. markup.font(theme.font, stdout))
    end
)
top_panel.create = function(s)

   -- Tags
   awful.tag(awful.util.tagnames, s, awful.layout.layouts)

   -- Create a promptbox for each screen
   s.mypromptbox = awful.widget.prompt()
   -- Create a taglist widget
   s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

   -- Create a tasklist widget
   s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

   local panel = awful.wibar({
      screen = s,
      position = "top",
      ontop = true,
      height = beautiful.top_panel_height,
      width = s.geometry.width,
   })

   panel:setup {
      expand = "none",
      layout = wibox.layout.align.horizontal,
      { -- Left widgets
         layout = wibox.layout.fixed.horizontal,
         s.mytaglist,
      },
      { -- Middle widgets
         layout = wibox.layout.fixed.horizontal,
         s.mypromptbox,
         s.mytasklist, 
      },
      { -- Right widgets
         layout = wibox.layout.fixed.horizontal,
         wibox.layout.margin(wibox.widget.systray(), 0, 0, 3, 3),
         volume.widget,
         require("widgets.bluetooth"),
         require("widgets.wifi"),
         require("widgets.battery"),
         require("widgets.layout-box")
      },
      require("widgets.calendar"),
      clock
   }

end

return top_panel
