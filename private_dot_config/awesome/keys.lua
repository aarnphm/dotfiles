-- keys.lua

-- ===================================================================
-- Default variable
-- ===================================================================
local awful         = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local defaults      = require("defaults")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local lain          = require("external.lain")
local freedesktop   = require("external.freedesktop")
require("awful.hotkeys_popup.keys")

-- define defaults variables
local modkey     = defaults.modkey
local altkey     = defaults.altkey
local ctrl       = defaults.ctrl
local shift      = defaults.shift
local sleep      = "systemctl suspend"
local reboot     = "systemctl reboot"
local poweroff   = "systemctl poweroff"

-- ===================================================================
-- Main menu
-- ===================================================================
local myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    { "manual", defaults.terminal .. " -e man awesome" },
    { "edit config", string.format("%s -e %s %s", defaults.terminal, defaults.editor, awesome.conffile) },
    {"restart", awesome.restart},
    {"quit", function() awesome.quit() end },
    {"sleep", sleep, beautiful.sleep},
    {"reboot", reboot, beautiful.reboot},
    {"poweroff", poweroff, beautiful.poweroff}
}
awful.util.mymainmenu =
freedesktop.menu.build(
    {
        icon_size = beautiful.menu_height or dpi(16),
        before = {
            {"Awesome", myawesomemenu, beautiful.awesome_icon}
        },
        after = {
            {"Open terminal", defaults.terminal}
        }
    }
    )
-- ===================================================================
-- Client keys bindings, can be used to modify and move clients around
-- screens in given tags
-- ===================================================================

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings(
        {
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
        }
        )
    end)

    awful.keyboard.append_global_keybindings({
            awful.key({modkey, ctrl}, "space",
                awful.client.floating.toggle,
                {description = "toggle floating", group = "client"}
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
            -- Window switcher
            awful.key({ altkey }, "Tab",
                function ()
                    window_switcher_show(awful.screen.focused())
                end,
                {description = "activate window switcher", group = "client"}),
        })

    -- ===================================================================
    -- Global key bindings, including application shortcut as well as layout
    -- manipulation
    -- ===================================================================

    awful.keyboard.append_global_keybindings({
            -- ===================================================================
            -- Hotkeys
            -- ===================================================================
            awful.key({modkey}, "s",
                hotkeys_popup.show_help,
                {description = "show help", group = "awesome"}
                ),
            awful.key({ctrl, modkey}, "r",
                awesome.restart,
                {description = "reload awesome", group = "awesome"}),
            awful.key({ctrl, modkey}, "q",
                awesome.quit, {description = "quit awesome", group = "awesome"}),
            awful.key({ctrl, altkey}, "\\",
                function()
                    -- naughty.suspend()
                    awful.util.spawn_with_shell(defaults.lock)
                end,
                {description = "lock screen", group = "awesome"}
                ),

            -- ===================================================================
            -- defaults.ult client focus and swap
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
            awful.key({modkey}, "space",
                function() awful.layout.inc(1) end,
                {description = "select next", group = "layout"}
                ),
            awful.key({modkey, shift}, "space",
                function() awful.layout.inc(-1) end,
                {description = "select previous", group = "layout"}),

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
            -- On the fly useless gaps change
            awful.key({modkey, shift},"-",
                function()
                    lain.util.useless_gaps_resize(1)
                end,
                {description = "increment useless gaps", group = "layout"}
                ),
            awful.key({modkey, shift},"=",
                function()
                    lain.util.useless_gaps_resize(-1)
                end,
                {description = "decrement useless gaps", group = "layout"}
                ),
            awful.key({ctrl, modkey}, "h", awful.tag.viewprev,
                {description = "view previous", group = "tag"}),
            awful.key({ctrl, modkey}, "l", awful.tag.viewnext,
                {description = "view next", group = "tag"}),
            -- awful.key({modkey}, "Tab", awful.tag.history.restore(awful.screen.focused(), 1)
            --     {description="go to previous tag", group="tag"}),

            -- ===================================================================
            -- Switch screens focus
            -- ===================================================================
            awful.key({ctrl, altkey}, "l",
                function()
                    awful.screen.focus_relative(1)
                end,
                {description = "focus the next screen", group = "screen"}
                ),
            awful.key({ctrl, altkey}, "h",
                function()
                    awful.screen.focus_relative(-1)
                end,
                {description = "focus the next screen", group = "screen"}
                ),

            -- ===================================================================
            -- Application shortcut
            -- ===================================================================
            awful.key({modkey}, "r",
                function()
                    awful.spawn('rofi -show run')
                end,
                {description = "run programs", group = "launcher"}
                ),
            -- awful.key({modkey}, "z",
            --     function()
            --         awful.screen.focused().quake:toggle()
            --     end,
            --     {description = "dropdown application", group = "launcher"}
            --     ),
            awful.key({modkey}, "e",
                function()
                    awful.spawn.easy_async_with_shell('dmenu-edit-config', {
                            stderr = function(line)
                                naughty.notify { text = "error: "..line }
                            end,
                        })
                end,
                {description = "edit config files", group = "launcher"}
                ),
            awful.key({shift, altkey}, "t",
                function()
                    awful.spawn("alacritty")
                end,
                {description = "open kitty", group = "launcher"}
                ),
            awful.key({ctrl, altkey}, "p",
                function()
                    awful.spawn("termite")
                end,
                {description = "open termite", group = "launcher"}
                ),
            awful.key({ctrl, altkey}, "t",
                function()
                    -- awful.spawn("kitty -e tmux")
                    awful.spawn("alacritty -e tmux")
                end,
                {description = "open tmux", group = "launcher"}
                ),
            awful.key({shift, modkey}, "m",
                function()
                    awful.spawn(defaults.spotify)
                end,
                {description = "run spotify", group = "launcher"}
                ),
            awful.key({modkey}, "p",
                function()
                    awful.spawn(defaults.screenshot)
                end,
                {description = "take a screenshot", group = "launcher"}
                ),
            awful.key({modkey, shift}, "b",
                function()
                    awful.spawn("chromium")
                end,
                {description = "open brave", group = "launcher"}
                ),
            awful.key({modkey}, "b",
                function()
                    awful.spawn(defaults.browser)
                end,
                {description = "open default browser", group = "launcher"}
                ),
            awful.key({ctrl}, "space",
                function()
                    awful.spawn(defaults.launcher)
                end,
                {description = "show rofi", group = "launcher"}
                ),

            -- ===================================================================
            -- Volume and misc controls
            -- ===================================================================
            awful.key({}, "XF86AudioRaiseVolume",
                function()
                    -- pamixer -i 3
                    awful.spawn("amixer set Master 5%+")
                end,
                {description = "volume up Master", group = "volume"}
                ),
            awful.key({}, "XF86AudioLowerVolume",
                function()
                    -- pamixer -d 3
                    awful.spawn("amixer set Master 5%-")
                end,
                {description = "volume down Master", group = "volume"}
                ),
            awful.key({}, "XF86AudioMute",
                function()
                    awful.spawn("amixer -q set Master toggle")
                end,
                {description = "toggle mute Master", group = "volume"}
                ),
            awful.key({}, "XF86AudioPlay",
                function()
                    awful.spawn("playerctl play-pause")
                end,
                {description = "Play/Pause current song", group = "volume"}
                ),
            awful.key({}, "XF86AudioPrev",
                function()
                    awful.spawn("playerctl previous")
                end,
                {description = "Previous song", group="volume"}
                ),
            awful.key({}, "XF86AudioNext",
                function()
                    awful.spawn("playerctl next")
                end,
                {description = "Next song", group="volume"}
                )
        })

    -- ===================================================================
    -- Bind all key numbers to tags.
    -- Be careful: we use keycodes to make it works on any keyboard layout.
    -- This should map on the top row of your keyboard, usually 1 to 9.
    -- ===================================================================
    awful.keyboard.append_global_keybindings(
        {
            awful.key {
                modifiers = {modkey},
                keygroup = "numrow",
                description = "only view tag",
                group = "tag",
                on_press = function(index)
                    local screen = awful.screen.focused()
                    local tag = screen.tags[index]
                    if tag then tag:view_only() end
                end
            },
            awful.key {
                modifiers = {modkey, ctrl},
                keygroup = "numrow",
                -- helpers.lua
                description = "toggle tag",
                group = "tag",
                on_press = function(index)
                    local screen = awful.screen.focused()
                    local tag = screen.tags[index]
                    if tag then awful.tag.viewtoggle(tag) end
                end
            },
            awful.key {
                modifiers = {modkey, shift},
                keygroup = "numrow",
                description = "move focused client to tag",
                group = "tag",
                on_press = function(index)
                    if client.focus then
                        local tag = client.focus.screen.tags[index]
                        if tag then client.focus:move_to_tag(tag) end
                    end
                end
            },
            awful.key {
                modifiers = {modkey, ctrl, shift},
                keygroup = "numrow",
                description = "toggle focused client on tag",
                group = "tag",
                on_press = function(index)
                    if client.focus then
                        local tag = client.focus.screen.tags[index]
                        if tag then client.focus:toggle_tag(tag) end
                    end
                end
            },
            awful.key {
                modifiers = {modkey},
                keygroup = "numpad",
                description = "select layout directly",
                group = "layout",
                on_press = function(index)
                    local t = awful.screen.focused().selected_tag
                    if t then t.layout = t.layouts[index] or t.layout end
                end
            }
        })

    -- ===================================================================
    -- mouse support for normies
    -- ===================================================================

    client.connect_signal("request::default_mousebindings", function()
        awful.mouse.append_client_mousebindings(
            {
                awful.button({}, 1, function(c)
                c:activate{context = "mouse_click"} end),
                awful.button({modkey}, 1, function(c)
                c:activate{context = "mouse_click", action = "mouse_move"} end),
                awful.button({modkey}, 3, function(c)
                c:activate{context = "mouse_click", action = "mouse_resize"} end)
            }
            )
        end)
