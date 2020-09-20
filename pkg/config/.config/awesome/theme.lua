-- ===================================================================
-- Initialization
-- ===================================================================
local os = os
local dpi   = require("beautiful.xresources").apply_dpi

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

theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"
theme.taglist_squares_sel                       = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"
theme.layout_tile                               = theme.dir .. "/icons/layouts/tilew.png"
theme.layout_tileleft                           = theme.dir .. "/icons/layouts/tileleftw.png"
theme.layout_tilebottom                         = theme.dir .. "/icons/layouts/tilebottomw.png"
theme.layout_tiletop                            = theme.dir .. "/icons/layouts/tiletopw.png"
theme.layout_fairv                              = theme.dir .. "/icons/layouts/fairvw.png"
theme.layout_fairh                              = theme.dir .. "/icons/layouts/fairhw.png"
theme.layout_cornerne                           = theme.dir .. "/icons/layouts/cornernew.png"
theme.layout_cornernw                           = theme.dir .. "/icons/layouts/cornernww.png"
theme.layout_spiral                             = theme.dir .. "/icons/layouts/spiralw.png"
theme.layout_dwindle                            = theme.dir .. "/icons/layouts/dwindlew.png"
theme.layout_max                                = theme.dir .. "/icons/layouts/maxw.png"
theme.layout_floating                           = theme.dir .. "/icons/layouts/floatingw.png"

return theme
