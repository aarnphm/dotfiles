-- ===================================================================
-- Initialization
-- ===================================================================

local awful        = require("awful")
local theme_assets = require("beautiful.theme_assets")
local xresources   = require("beautiful.xresources")
local dpi          = xresources.apply_dpi
local xrdb         = xresources.get_current_theme()
local gears        = require("gears")
local gfs          = require("gears.filesystem")
local themes_path  = gfs.get_themes_dir()
local helpers      = require("helpers")

-- ===================================================================
-- Theme Variables
-- ===================================================================

-- Inherit default theme
local theme     = dofile(themes_path .. "default/theme.lua")
local icon_path = gfs.get_configuration_dir() .. "icons/"

-- ===================================================================
-- Notification centre
-- ===================================================================

theme.clear_icon        = icon_path .. "notification-centre/clear.png"
theme.clear_grey_icon   = icon_path .. "notification-centre/clear_grey.png"
theme.notification_icon = icon_path .. "notification-centre/notification.png"
theme.delete_icon       = icon_path .. "notification-centre/delete.png"
theme.delete_grey_icon  = icon_path .. "notification-centre/delete_grey.png"
theme.awesome_icon      = icon_path .. "default/awesome.png"
theme.terminal_icon     = icon_path .. "default/terminal.png"

-- ===================================================================
-- Load $HOME/.Xresources colors and set fallback
-- ===================================================================

theme.xbackground = xrdb.background  or "#30333d"
theme.xforeground = xrdb.foreground  or "#ffffff"
theme.xcolor0     = xrdb.color0      or "#292b34"
theme.xcolor1     = xrdb.color1      or "#f9929b"
theme.xcolor2     = xrdb.color2      or "#7ed491"
theme.xcolor3     = xrdb.color3      or "#fbdf90"
theme.xcolor4     = xrdb.color4      or "#a3b8ef"
theme.xcolor5     = xrdb.color5      or "#ccaced"
theme.xcolor6     = xrdb.color6      or "#9ce5c0"
theme.xcolor7     = xrdb.color7      or "#ffffff"
theme.xcolor8     = xrdb.color8      or "#585e74"
theme.xcolor9     = xrdb.color9      or "#fca2aa"
theme.xcolor10    = xrdb.color10     or "#a5d4af"
theme.xcolor11    = xrdb.color11     or "#fbeab9"
theme.xcolor12    = xrdb.color12     or "#bac8ef"
theme.xcolor13    = xrdb.color13     or "#d7c1ed"
theme.xcolor14    = xrdb.color14     or "#c7e5d6"
theme.xcolor15    = xrdb.color15     or "#eaeaea"

-- ===================================================================
-- Layouts
-- ===================================================================

theme.layout_fairh      = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv      = themes_path.."default/layouts/fairvw.png"
theme.layout_floating   = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier  = themes_path.."default/layouts/magnifierw.png"
theme.layout_max        = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile       = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop    = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral     = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle    = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw   = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne   = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw   = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse   = themes_path.."default/layouts/cornersew.png"

-- ===================================================================
-- Background colors
-- ===================================================================

theme.bg_dark     = theme.xcolor0
theme.bg_normal   = theme.xbackground
theme.bg_focus    = theme.xcolor8
theme.bg_urgent   = theme.xcolor8
theme.bg_minimize = theme.xcolor8

-- ===================================================================
-- Foreground colors
-- ===================================================================

theme.fg_normal    = theme.xcolor7
theme.fg_focus     = theme.xcolor4
theme.fg_urgent    = theme.xcolor3
theme.fg_minimize  = theme.xcolor8
theme.button_close = theme.xcolor1

-- ===================================================================
-- Borders
-- ===================================================================

theme.border_width        = dpi(3)
theme.border_normal       = theme.xcolor0
theme.border_focus        = theme.fg_normal
theme.border_radius       = dpi(12)
theme.client_radius       = dpi(12)
theme.widget_border_width = dpi(2)
theme.widget_border_color = theme.xcolor0

-- ===================================================================
-- Font
-- ===================================================================
theme.fontname     = "mononoki Nerd Font "
theme.font         = theme.fontname .. "12"
theme.icon_font    = theme.fontname .. "10"
theme.font_taglist = "InconsolataGo Nerd Font 18"
theme.max_font     = "InconsolataGo Nerd Font 10"

-- ===================================================================
-- Taglist
-- ===================================================================

theme.taglist_font          = theme.font_taglist
local taglist_square_size   = dpi(0)
theme.taglist_squares_sel   = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)
theme.taglist_bg            = theme.wibar_bg
theme.taglist_bg_focus      = theme.xcolor8
theme.taglist_fg_focus      = theme.xcolor4
theme.taglist_bg_urgent     = theme.xcolor0
theme.taglist_fg_urgent     = theme.xcolor6
theme.taglist_bg_occupied   = theme.xcolor0
theme.taglist_fg_occupied   = theme.xcolor6
theme.taglist_bg_empty      = theme.xcolor0
theme.taglist_fg_empty      = theme.xcolor8
theme.taglist_bg_volatile   = transparent
theme.taglist_fg_volatile   = theme.xcolor11
theme.taglist_shape_focus   = helpers.rrect(theme.border_radius - 3)
theme.taglist_disable_icon  = true

-- ===================================================================
--  Tasklist
-- ===================================================================

theme.tasklist_font              = theme.fontname .. "18"
theme.tasklist_plain_task_name   = true
theme.tasklist_bg_focus          = theme.xcolor0
theme.tasklist_fg_focus          = theme.xcolor6
theme.tasklist_bg_minimize       = theme.xcolor0 .. "70"
theme.tasklist_fg_minimize       = theme.xforeground .. "70"
theme.tasklist_bg_normal         = theme.xcolor0
theme.tasklist_fg_normal         = theme.xforeground
theme.tasklist_disable_task_name = false
theme.tasklist_disable_icon      = true
theme.tasklist_bg_urgent         = theme.xcolor0
theme.tasklist_fg_urgent         = theme.xcolor1
theme.tasklist_spacing           = dpi(2)
theme.tasklist_align             = "center"

-- ===================================================================
-- Titlebars
-- ===================================================================

theme.titlebar_size      = dpi(40)
theme.titlebar_height    = dpi(20)
theme.titlebar_bg_focus  = theme.xbackground
theme.titlebar_bg_normal = theme.xbackground
theme.titlebar_fg_focus  = theme.xbackground
theme.titlebar_fg_normal = theme.xbackground

-- ===================================================================
-- Edge snap
-- ===================================================================

theme.snap_bg    = theme.xcolor4
theme.snap_shape = helpers.rrect(theme.border_radius)

-- ===================================================================
-- Prompts
-- ===================================================================

theme.prompt_bg = transparent
theme.prompt_fg = theme.xforeground

-- ===================================================================
-- Menu
-- ===================================================================
--
theme.menu_font         = theme.font
theme.menu_bg_focus     = theme.xcolor4
theme.menu_fg_focus     = theme.xcolor7
theme.menu_bg_normal    = theme.xbackground
theme.menu_fg_normal    = theme.xcolor7
theme.menu_height       = dpi(20)
theme.menu_width        = dpi(190)
theme.menu_border_color = "#0000000"
theme.menu_border_width = theme.border_width
theme.menu_submenu_icon = icon_path .. "default/submenu.png"

-- ===================================================================
-- Tooltips
-- ===================================================================

theme.tooltip_font         = theme.font
theme.tooltip_bg           = theme.xcolor0
theme.tooltip_fg           = theme.xforeground
theme.tooltip_border_width = theme.border_width
theme.tooltip_border_color = theme.xcolor0
theme.tooltip_opacity      = 1
theme.tooltip_align        = "left"

-- ===================================================================
-- Hotkeys Popup
-- ===================================================================

theme.hotkeys_border_color     = theme.xcolor0
theme.hotkeys_font             = "mononoki Nerd Font 12"
theme.hotkeys_description_font = "mononoki Nerd Font 10"
theme.hotkeys_shape            = helpers.rrect(theme.border_radius - 3)

-- ===================================================================
-- Layout List
-- ===================================================================

theme.layoutlist_border_color = theme.xcolor8
theme.layoutlist_border_width = theme.border_width
-- Recolor Layout icons:
theme = theme_assets.recolor_layout(theme, theme.xforeground)

-- ===================================================================
-- Gaps
-- ===================================================================

theme.useless_gap = dpi(2)

-- ===================================================================
-- Wibar
-- ===================================================================

theme.wibar_height  = dpi(35)
theme.wibar_margin  = dpi(15)
theme.wibar_spacing = dpi(15)
theme.wibar_bg      = theme.xbackground

-- ===================================================================
-- Systray - Weather
-- ===================================================================

theme.systray_icon_spacing = dpi(10)
theme.bg_systray           = theme.xcolor0
theme.systray_icon_size    = dpi(15)
theme.weather_city         = "Hanoi"

return theme
