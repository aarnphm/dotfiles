-- ===================================================================
-- Initialization
-- ===================================================================

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
local icon_path = gears.filesystem.get_configuration_dir() .. "icons/"

-- ===================================================================
-- Load $HOME/.Xresources colors and set fallback
-- ===================================================================

theme.xbackground = xrdb.background or "#30333d"
theme.xforeground = xrdb.foreground or "#ffffff"
theme.xcolor0     = xrdb.color0 or "#292b34"
theme.xcolor1     = xrdb.color1 or "#f9929b"
theme.xcolor2     = xrdb.color2 or "#7ed491"
theme.xcolor3     = xrdb.color3 or "#fbdf90"
theme.xcolor4     = xrdb.color4 or "#a3b8ef"
theme.xcolor5     = xrdb.color5 or "#ccaced"
theme.xcolor6     = xrdb.color6 or "#9ce5c0"
theme.xcolor7     = xrdb.color7 or "#ffffff"
theme.xcolor8     = xrdb.color8 or "#585e74"
theme.xcolor9     = xrdb.color9 or "#fca2aa"
theme.xcolor10    = xrdb.color10 or "#a5d4af"
theme.xcolor11    = xrdb.color11 or "#fbeab9"
theme.xcolor12    = xrdb.color12 or "#bac8ef"
theme.xcolor13    = xrdb.color13 or "#d7c1ed"
theme.xcolor14    = xrdb.color14 or "#c7e5d6"
theme.xcolor15    = xrdb.color15 or "#eaeaea"

-- ===================================================================
-- Font
-- ===================================================================

theme.font_name     = "Fira Code Nerd Font"
theme.font_alt      = "mononoki Nerd Font"
theme.font          = theme.font_name .. "9"
theme.font_taglist  = theme.font_alt .. "8"
theme.font_tasklist = theme.font_alt .. "8"

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

theme.border_width        = dpi(5)
theme.border_normal       = theme.fg_normal
theme.border_focus        = theme.bg_focus
theme.border_radius       = dpi(5)
theme.client_radius       = dpi(12)
theme.widget_border_width = dpi(2)
theme.widget_border_color = theme.fg_normal

-- ===================================================================
-- Taglist
-- ===================================================================

local taglist_square_size   = dpi(1)
theme.taglist_squares_sel   = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)
theme.taglist_font          = theme.font_taglist
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

theme.tasklist_font              = theme.font_tasklist
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

theme.snap_bg = theme.xcolor4
theme.snap_shape = helpers.rrect(theme.border_radius)

-- ===================================================================
-- Prompts
-- ===================================================================

theme.prompt_bg = transparent
theme.prompt_fg = theme.xforeground

-- ===================================================================
-- Tooltips
-- ===================================================================

theme.tooltip_font         = theme.font_alt
theme.tooltip_bg           = theme.xcolor0
theme.tooltip_fg           = theme.xforeground
theme.tooltip_border_width = theme.border_width
theme.tooltip_border_color = theme.xcolor0
theme.tooltip_opacity      = 1
theme.tooltip_align        = "left"

-- ===================================================================
-- Menu
-- ===================================================================

theme.menu_font         = theme.font_alt
theme.menu_bg_focus     = theme.xcolor4
theme.menu_fg_focus     = theme.xcolor7
theme.menu_bg_normal    = theme.xbackground
theme.menu_fg_normal    = theme.xcolor7
theme.menu_submenu_icon = gears.filesystem.get_configuration_dir() .. "theme/icons/submenu.png"
theme.menu_height       = dpi(20)
theme.menu_width        = dpi(130)
theme.menu_border_color = "#0000000"
theme.menu_border_width = theme.border_width

-- ===================================================================
-- Hotkeys Popup
-- ===================================================================

theme.hotkeys_font         = theme.font
theme.hotkeys_border_color = theme.xcolor0

-- ===================================================================
-- Gaps
-- ===================================================================

theme.useless_gap = dpi(2)

-- ===================================================================
-- Wibar
-- ===================================================================

theme.wibar_height = dpi(33)
theme.wibar_margin = dpi(15)
theme.wibar_spacing = dpi(15)
theme.wibar_bg = theme.xbackground

-- ===================================================================
-- Systray
-- ===================================================================

theme.systray_icon_spacing = dpi(5)
theme.bg_systray = theme.xcolor0
theme.systray_icon_size = dpi(13)

return theme
