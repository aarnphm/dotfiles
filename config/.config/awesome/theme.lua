-- ===================================================================
-- Initialization
-- ===================================================================
local os  = os
local dpi = require("beautiful.xresources").apply_dpi


-- ===================================================================
-- Theme Variables
-- ===================================================================

local theme                    = {}
theme.dir                      = os.getenv("HOME") .. "/.config/awesome"
theme.icon_theme               = "ePapirus"
theme.font                     = "InconsolataGo Nerd Font 9"
theme.notification_font        = theme.font
theme.fg_normal                = "#FEFEFE"
theme.fg_focus                 = "#EA6F81"
theme.fg_urgent                = "#CC9393"
theme.bg_normal                = "#000000"
theme.bg_focus                 = "#313131"
theme.bg_urgent                = "#1A1A1A"
theme.bg_systray               = theme.bg_normal
theme.systray_opacity          = "55"
theme.border_width             = dpi(1)
theme.border_normal            = "#3F3F3F"
-- theme.border_focus          = "#000000"
-- theme.border_marked         = "#000000"
theme.border_focus             = "#7F7F7F"
theme.border_marked            = "#CC9393"
theme.tasklist_bg_focus        = theme.bg_normal
theme.titlebar_bg_focus        = theme.bg_focus
theme.titlebar_bg_normal       = theme.bg_normal
theme.titlebar_fg_focus        = theme.fg_focus
theme.menu_height              = dpi(16)
theme.menu_width               = dpi(140)
theme.useless_gap              = dpi(3)
theme.notification_max_width   = dpi(250)
theme.notification_max_height  = dpi(200)
theme.notification_icon_size   = dpi(32)
theme.tasklist_plain_task_name = true
theme.tasklist_disable_icon    = true
theme.collision_bg_focus       = "#000000"
theme.collision_fg_focus       = "#000000"
theme.collision_resize_bg      = '#000000'
theme.collision_resize_fg      = '#000000'
theme.collision_resize_shape   = nil


-- ===================================================================
-- Icons
-- ===================================================================

theme.menu_submenu_icon     = theme.dir .. "/icons/submenu.png"
theme.taglist_squares_sel   = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel = theme.dir .. "/icons/square_unsel.png"
theme.layout_tile           = theme.dir .. "/icons/layouts/tilew.png"
theme.layout_tileleft       = theme.dir .. "/icons/layouts/tileleftw.png"
theme.layout_tilebottom     = theme.dir .. "/icons/layouts/tilebottomw.png"
theme.layout_tiletop        = theme.dir .. "/icons/layouts/tiletopw.png"
theme.layout_fairv          = theme.dir .. "/icons/layouts/fairvw.png"
theme.layout_fairh          = theme.dir .. "/icons/layouts/fairhw.png"
theme.layout_cornerne       = theme.dir .. "/icons/layouts/cornernew.png"
theme.layout_cornernw       = theme.dir .. "/icons/layouts/cornernww.png"
theme.layout_spiral         = theme.dir .. "/icons/layouts/spiralw.png"
theme.layout_dwindle        = theme.dir .. "/icons/layouts/dwindlew.png"
theme.layout_max            = theme.dir .. "/icons/layouts/maxw.png"
theme.layout_floating       = theme.dir .. "/icons/layouts/floatingw.png"
theme.menu_submenu_icon     = theme.dir .. "/icons/submenu.png"
theme.taglist_squares_sel   = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel = theme.dir .. "/icons/square_unsel.png"
theme.layout_tile           = theme.dir .. "/icons/tile.png"
theme.layout_tileleft       = theme.dir .. "/icons/tileleft.png"
theme.layout_tilebottom     = theme.dir .. "/icons/tilebottom.png"
theme.layout_tiletop        = theme.dir .. "/icons/tiletop.png"
theme.layout_fairv          = theme.dir .. "/icons/fairv.png"
theme.layout_fairh          = theme.dir .. "/icons/fairh.png"
theme.layout_spiral         = theme.dir .. "/icons/spiral.png"
theme.layout_dwindle        = theme.dir .. "/icons/dwindle.png"
theme.layout_max            = theme.dir .. "/icons/max.png"
theme.layout_fullscreen     = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier      = theme.dir .. "/icons/magnifier.png"
theme.layout_floating       = theme.dir .. "/icons/floating.png"
theme.widget_ac             = theme.dir .. "/icons/ac.png"
theme.widget_battery        = theme.dir .. "/icons/battery.png"
theme.widget_battery_low    = theme.dir .. "/icons/battery_low.png"
theme.widget_battery_empty  = theme.dir .. "/icons/battery_empty.png"
theme.widget_mem            = theme.dir .. "/icons/mem.png"
theme.widget_cpu            = theme.dir .. "/icons/cpu.png"
theme.widget_temp           = theme.dir .. "/icons/temp.png"
theme.widget_net            = theme.dir .. "/icons/net.png"
theme.widget_hdd            = theme.dir .. "/icons/hdd.png"
theme.widget_music          = theme.dir .. "/icons/note.png"
theme.widget_music_on       = theme.dir .. "/icons/note_on.png"
theme.widget_vol            = theme.dir .. "/icons/vol.png"
theme.widget_vol_low        = theme.dir .. "/icons/vol_low.png"
theme.widget_vol_no         = theme.dir .. "/icons/vol_no.png"
theme.widget_vol_mute       = theme.dir .. "/icons/vol_mute.png"

return theme
