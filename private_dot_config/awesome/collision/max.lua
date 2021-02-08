local capi       = {screen = screen, client = client, mouse = mouse}
local wibox      = require("wibox")
local awful      = require("awful")
local module = {}

-- local w = nil

-- local function init()
--   w = wibox{}
--   w.ontop = true
--   w.visible = true
-- end

local margin = 15

local function change_tag(s,direction,is_swap)
  local s = capi.client.focus and capi.client.focus.screen or capi.mouse.screen
  if not is_swap then
    awful.tag[direction == "left" and "viewprev" or "viewnext"](s)
  else
    -- Move the tag
    local t = capi.screen[s].selected_tag
    local cur_idx,count = awful.tag.getidx(t),#capi.screen[s].tags
    cur_idx = cur_idx + (direction == "left" and -1 or 1)
    cur_idx = cur_idx == 0 and count or cur_idx > count and 1 or cur_idx
    t.index = cur_idx
  end
  local tags = capi.screen[s].tags
  local fk = awful.util.table.hasitem(tags,capi.screen[s].selected_tag)
end

function module.display_tags(s,direction,c,is_swap,is_max)
  -- if not w then
  --   init()
  -- end
  change_tag(s,direction,is_swap)
end

function module.change_tag(mod,key,event,direction,is_swap,is_max)
  local s = capi.client.focus and capi.client.focus.screen or capi.mouse.screen
  change_tag(s,direction,is_swap)
  return true
end

return module
