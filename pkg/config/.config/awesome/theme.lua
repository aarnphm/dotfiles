-- ===================================================================
-- Initialization
-- ===================================================================


local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- define module table
local theme = {}


-- ===================================================================
-- Theme Variables
-- ===================================================================


-- Font
theme.font = "InconsolataGo Nerd Font 10"
theme.title_font = "SFMono Nerd Font 10"
theme.dir = os.getenv("HOME") .. "/.config/awesome"
-- Background
theme.bg_normal = "#000000"
-- theme.bg_dark = "#"
theme.bg_focus = theme.bg_normal
theme.bg_urgent = "#1A1A1A"
theme.bg_systray = theme.bg_normal

-- Foreground
theme.fg_normal = "#DDDDFF"
theme.fg_focus = "#EA6F81"
theme.fg_urgent = "#CC9393"
theme.fg_minimize = "#FFFFFF"

-- Window Gap Distance
theme.useless_gap = dpi(5)

-- Show Gaps if Only One Client is Visible
theme.gap_single_client = false

-- Window Borders
theme.border_width = dpi(0)
theme.border_normal = theme.bg_normal
theme.border_focus = "#ff8a65"
theme.border_marked = theme.fg_urgent

-- Taglist
theme.taglist_bg_empty = theme.bg_normal
theme.taglist_bg_focus = theme.bg_focus
theme.taglist_squares_sel = theme.dir .. "/icons/folders/square_sel.png"
theme.taglist_squares_unsel = theme.dir .. "/icons/folders/square_unsel.png"
-- Tasklist
theme.tasklist_font = theme.font

theme.tasklist_bg_normal = theme.bg_normal
theme.tasklist_bg_focus = theme.bg_focus
theme.tasklist_bg_urgent = theme.bg_urgent

theme.tasklist_fg_focus = theme.fg_focus
theme.tasklist_fg_urgent = theme.fg_urgent
theme.tasklist_fg_normal = theme.fg_normal

-- Panel Sizing
theme.top_panel_height = dpi(26)

-- Notification Sizing
theme.notification_max_width = dpi(350)


-- ===================================================================
-- Icons
-- ===================================================================


-- You can use your own layout icons like this:
theme.layout_tile = theme.dir .. "/icons/layouts/view-quilt.png"
theme.layout_floating = theme.dir .. "/icons/layouts/view-float.png"
theme.layout_max = theme.dir .. "/icons/layouts/arrow-expand-all.png"

theme.icon_theme = "ePapirus"

-- return theme
return theme
