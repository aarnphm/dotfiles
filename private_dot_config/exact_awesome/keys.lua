-- keys.lua

-- ===================================================================
-- Default variable
-- ===================================================================
local gears         = require("gears")
local awful         = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local naughty       = require("naughty")

-- define defaults variables
local def        = require("defaults")
local modkey     = def.modkey
local altkey     = def.altkey
local ctrl       = def.ctrl
local shift      = def.shift
local cycle_prev = true

-- ===================================================================
-- Client keys bindings, can be used to modify and move clients around 
-- screens in given tags
-- ===================================================================

clientkeys = gears.table.join(

    awful.key({modkey}, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}
        ),
    awful.key({modkey},"q",
        function(c)
            c:kill()
        end,
        {description = "close", group = "client"}
        ),
    awful.key({modkey, ctrl}, "space",
        awful.client.floating.toggle,
        {description = "toggle floating", group = "client"}
        ),
    awful.key({modkey, ctrl}, "Return",
        function(c)
            c:swap(awful.client.getmaster())
        end,
        {description = "move to master", group = "client"}
        ),
    awful.key({modkey}, "o",
        function(c)
            c:move_to_screen()
        end,
        {description = "move to screen", group = "client"}
        ),
    awful.key({modkey}, "t",
        function(c)
            c.ontop = not c.ontop
        end,
        {description = "toggle keep on top", group = "client"}
        ),
    awful.key({modkey}, "n",
        function(c)
        -- The client currently has the input focus, so it cannot be minimized, 
        -- since minimized clients can't have the focus.
            c.minimized = true
        end,
        {description = "minimize", group = "client"}
        ),
    awful.key({modkey, ctrl}, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                client.focus = c
                c:raise()
            end
        end,
        {description = "restore minimized", group = "client"}
        ),
    awful.key({modkey}, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        {description = "maximize", group = "client"}
        ),
        -- normal Alt-Tab behaviour
    awful.key({altkey}, "Tab",
        function()
            if cycle_prev then
                awful.client.focus.history.previous()
            else
                awful.client.focus.byidx(-1)
            end
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "cycle with previous/go back", group = "client"}
        )
    )

-- ===================================================================
-- Global key bindings, including application shortcut as well as layout
-- manipulation
-- ===================================================================

globalkeys = gears.table.join(

    -- ===================================================================
    -- Hotkeys
    -- ===================================================================
    awful.key({modkey}, "s",
        hotkeys_popup.show_help,
        {description = "show help", group = "awesome"}
        ),
    awful.key({shift, modkey}, "r",
        awesome.restart,
        {description = "reload awesome", group = "awesome"}),
    awful.key({shift, modkey}, "q",
        awesome.quit, {description = "quit awesome", group = "awesome"}),
    awful.key({ctrl, altkey}, "\\",
        function()
            naughty.suspend()
            os.execute(def.lock)
        end,
        {description = "lock screen", group = "hotkeys"}
        ),

    -- ===================================================================
    -- Default client focus and swap
    -- ===================================================================
    awful.key({altkey, shift}, "j",
        function()
            awful.client.focus.byidx(1)
        end,
        {description = "focus next by index", group = "client"}
        ),
    awful.key({altkey, shift}, "k",
        function()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
        ),
    awful.key({altkey, shift}, "h",
        function()
            awful.client.swap.byidx(1)
        end,
        {description = "swap with next client by index", group = "client"}
        ),
    awful.key({altkey, shift}, "l",
        function()
            awful.client.swap.byidx(-1)
        end,
        {description = "swap with previous client by index", group = "client"}
        ),

    -- ===================================================================
    -- Layout manipulation
    -- ===================================================================
    awful.key({modkey, shift}, "l",
        function()
            awful.tag.incmwfact(0.05)
        end,
        {description = "increase master width factor", group = "layout"}
        ),
    awful.key({modkey, shift}, "h",
        function()
            awful.tag.incmwfact(-0.05)
        end,
        {description = "decrease master width factor", group = "layout"}
        ),
    awful.key({modkey, shift}, "k",
        function()
            awful.tag.incnmaster(1, nil, true)
        end,
        {description = "increase the number of master clients", group = "layout"}
        ),
    awful.key({modkey, shift}, "j",
        function()
            awful.tag.incnmaster(-1, nil, true)
        end,
        {description = "decrease the number of master clients", group = "layout"}
        ),

    -- ===================================================================
    -- Switch screens focus
    -- ===================================================================
    awful.key({ctrl}, "\\",
        function()
            awful.screen.focus_relative(1)
        end,
        {description = "focus the next screen", group = "screen"}
        ),

    -- ===================================================================
    -- Application shortcut
    -- ===================================================================
    awful.key({ctrl, altkey}, "1",
        function()
            awful.spawn(". $HOME/.screenlayout/one.sh")
        end,
        {description = "eDP scripts", group = "launcher"}
        ),
    awful.key({ctrl, altkey}, "2",
        function()
            awful.spawn(". $HOME/.screenlayout/dual-side.sh")
        end,
        {description = "dual monitor scripts", group = "launcher"}
        ),
    awful.key({ctrl, altkey}, "e",
        function()
            awful.spawn("./.dmenu/dmenu-edit-conf.sh")
        end,
        {description = "edit config files", group = "launcher"}
        ),
    awful.key({ctrl, altkey}, "t",
        function()
            awful.spawn(def.terminal)
        end,
        {description = "open a kitty", group = "launcher"}
        ),
    awful.key({shift, modkey}, "m",
        function()
            awful.spawn(def.spotify)
        end,
        {description = "run spotify", group = "launcher"}
        ),
    awful.key({shift, modkey}, "f",
        function()
            awful.spawn(def.filebrowser)
        end,
        {description = "open explorer", group = "launcher"}
        ),
    awful.key({shift, modkey}, "z",
        function()
            awful.spawn(def.zotero)
        end,
        {description = "run zotero", group = "launcher"}
        ),
    awful.key({modkey}, "p",
        function()
            awful.spawn(def.screenshot)
        end,
        {description = "take a screenshot", group = "launcher"}
        ),
    awful.key({modkey}, "b",
        function()
            awful.spawn(def.browser)
        end,
        {description = "open default browser", group = "launcher"}
        ),
    awful.key({ctrl}, "space",
        function()
            awful.spawn(def.launcher)
        end,
        {description = "show rofi", group = "launcher"}
        ),

    -- ===================================================================
    -- Volume and misc controls
    -- ===================================================================
    awful.key({}, "XF86AudioRaiseVolume",
        function()
            os.execute("amixer -q set Master 3%%+")
        end,
        {description = "volume up Master", group = "volume"}
        ),
    awful.key({}, "XF86AudioLowerVolume",
        function()
            os.execute("amixer -q set Master 3%%-")
        end,
        {description = "volume down Master", group = "volume"}
        ),
    awful.key({}, "XF86AudioMute",
        function()
            os.execute("amixer -q set Master toggle")
        end,
        {description = "toggle mute Master", group = "volume"}
        )
    )

-- ===================================================================
-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
-- ===================================================================
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move
    if i == 1 or i == 9 then
        descr_view = {description = "view tag #", group = "tag"}
        descr_toggle = {description = "toggle tag #", group = "tag"}
        descr_move = {description = "move focused client to tag #", group = "tag"}
    end
    globalkeys = gears.table.join(
        globalkeys,
        -- View tag only.
        awful.key({modkey}, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            descr_view
            ),
        -- Toggle tag display.
        awful.key({ctrl, modkey}, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            descr_toggle
            ),
        -- Move client to tag.
        awful.key({modkey, shift}, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            descr_move
            )
        )
end

-- ===================================================================
-- mouse support for normies
-- ===================================================================

clientbuttons = gears.table.join(
    awful.button({}, 1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end
        ),
    awful.button({modkey}, 1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.move(c)
        end
        ),
    awful.button({modkey}, 3,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.resize(c)
        end
        )
    )

-- ===================================================================
--  Define globals here
-- ===================================================================

root.keys(globalkeys)
