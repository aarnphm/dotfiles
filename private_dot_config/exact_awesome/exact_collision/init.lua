local capi   = {root=root,client=client,mouse=mouse, timer=timer, screen = screen, keygrabber = keygrabber}
local util   = require( "awful.util")
local awful  = require( "awful")
local glib   = require( "lgi").GLib
local unpack = unpack or table.unpack -- luacheck: globals unpack (compatibility with Lua 5.1)
local module = { _max = require("collision.max")}
local defaults = require("defaults")

local current_mode   = "focus"

local event_callback = {tag = module._max.change_tag}

local start_callback = {tag = module._max.display_tags}

local exit_callback  = {tag = module._max.hide}

local keys = { 
    up     = {"Up"    ,},
    down   = {"Down"  ,},
    left   = {"Left"  ,},
    right  = {"Right" ,},
}

local function exit_loop()
    capi.keygrabber.stop()
    return false
end

-- Event loop
local function start_loop(is_swap,is_max)
    capi.keygrabber.run(function(mod, key, event)
        -- Detect the direction
        for k,v in pairs(keys) do
            if util.table.hasitem(v,key) then
                if event == "press" then
                    if not event_callback[current_mode](mod,key,event,k,is_swap,is_max) then
                        return exit_loop()
                    end
                    return
                end
                return #mod > 0
            end
        end

        return exit_loop()
    end)
end

function module.tag(direction,swap,max)
    current_mode = "tag"
    local c = capi.client.focus
    module._max.display_tags((c) and c.screen or capi.mouse.screen,direction,c,swap,max)
    start_loop(swap,max)
end


local function new(k)
    -- Replace the keys array. The new one has to have a valid mapping
    keys = k or keys
    local aw = {}

    -- This have to be executed after rc.lua
    glib.idle_add(glib.PRIORITY_DEFAULT_IDLE, function()
        for k,v in pairs(keys) do
            for _,key_name in ipairs(v) do
                if key_name == "Left" or key_name == "Right" then
                    aw[#aw+1] = awful.key({ defaults.altkey, defaults.ctrl}, key_name, function () module.tag(k,nil ,true) end,
                        { description = "Select tag to the "..key_name, group = "Collision" })
                end
            end
        end
        capi.root.keys(awful.util.table.join(capi.root.keys(),unpack(aw)))
    end)

    return module
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })
