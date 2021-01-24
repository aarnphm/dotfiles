-- ===================================================================
-- Standard Library
-- ===================================================================

local os, root, awesome, client = os, root, awesome, client
local gears                     = require("gears")
local awful                     = require("awful")
local lain                      = require("lain")
local naughty                   = require("naughty")
local freedesktop               = require("freedesktop")
local switcher                  = require("awesome-switcher")
local menubar                   = require("menubar")
local wibox                     = require("wibox")
local beautiful                 = require("beautiful")
local dpi                       = require("beautiful.xresources").apply_dpi
local hotkeys_popup             = require("awful.hotkeys_popup").widget
-- Custom imports
local screen_height             = awful.screen.focused().geometry.height
local screen_width              = awful.screen.focused().geometry.width
local markup                    = lain.util.markup
-- Define tag layouts
awful.util.tagnames             = {"ano","media","web","meetings","games","code"}
awful.layout.layouts            = {awful.layout.suit.tile.right, awful.layout.suit.max, awful.layout.suit.tile, awful.layout.suit.tile.top, awful.layout.suit.max, awful.layout.suit.tile.top}
-- Custom keybinds
local modkey                    = "Mod4"
local altkey                    = "Mod1"
local sleep                     = "systemctl suspend"
local reboot                    = "systemctl reboot"
local poweroff                  = "systemctl poweroff"
local cycle_prev                = true
-- Autofocus a new client when previously focused one is closed
require("awful.autofocus")
-- Enable hotkeys help widget for VIM and other apps when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
-- Theme
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")
naughty.config.defaults.timeout = 1.2
-- ===================================================================
-- Error handling
-- ===================================================================

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)

if awesome.startup_errors then
    naughty.notify(
        {
            preset = naughty.config.presets.critical,
            title = "Oops, there were errors during startup!",
            text = awesome.startup_errors
        }
        )
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal(
        "debug::error",
        function(err)
            -- Make sure we don't go into an endless error loop
            if in_error then
                return
            end
            in_error = true

            naughty.notify(
                {
                    preset = naughty.config.presets.critical,
                    title = "Oops, an error happened!",
                    text = tostring(err)
                }
                )
            in_error = false
        end
        )
end

-- ===================================================================
-- Apps
-- ===================================================================

local apps = {
    terminal     = "alacritty",
    editor       = "nvim",
    gui_editor   = os.getenv("GUI_EDITOR") or "code",
    browser      = os.getenv("BROWSER") or "firefox",
    spotify      = "kdocker -qi /usr/share/icons/ePapirus/16x16/apps/spotify.svg spotify",
    zotero       = "kdocker -qi /usr/share/icons/ePapirus/32x32/apps/zotero.svg zotero",
    launcher     = "rofi -modi drun -i -p -show drun -show-icons",
    lock         = "xsecurelock",
    screenshot   = "gyazo",
    filebrowser  = "pcmanfm",
    zotero       = "/opt/zotero/zotero",
    audiocontrol = "pavucontrol",
    bluetooth    = "blueman-manager"
}

awful.util.terminal = apps.terminal

-- ===================================================================
-- Set Up Screen, Connect Signal and Mouse Support
-- ===================================================================

-- Mouse support
awful.util.taglist_buttons =
gears.table.join(
    awful.button(
        {},
        1,
        function(t)
            t:view_only()
        end
        ),
    awful.button(
        {modkey},
        1,
        function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end
        ),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button(
        {modkey},
        3,
        function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end
        )
    )

awful.util.tasklist_buttons =
gears.table.join(
    awful.button(
        {},
        1,
        function(c)
            if c == client.focus then
                c.minimized = true
            else
                -- c:emit_signal("request::activate", "tasklist", {raise = true})<Paste>

                -- Without this, the following
                -- :isvisible() makes no sense
                c.minimized = false
                if not c:isvisible() and c.first_tag then
                    c.first_tag:view_only()
                end
                -- This will also un-minimize
                -- the client, if needed
                client.focus = c
                c:raise()
            end
        end
        ),
    awful.button(
        {},
        2,
        function(c)
            c:kill()
        end
        ),
    awful.button(
        {},
        3,
        function()
            local instance = nil

            return function()
                if instance and instance.wibox.visible then
                    instance:hide()
                    instance = nil
                else
                    instance = awful.menu.clients({theme = {width = dpi(25)}})
                end
            end
        end
        )
    )

local clientkeys =
gears.table.join(
    awful.key(
        {modkey},
        "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}
        ),
    awful.key(
        {modkey},
        "q",
        function(c)
            c:kill()
        end,
        {description = "close", group = "client"}
        ),
    awful.key(
        {modkey, "Control"},
        "space",
        awful.client.floating.toggle,
        {description = "toggle floating", group = "client"}
        ),
    awful.key(
        {modkey, "Control"},
        "Return",
        function(c)
            c:swap(awful.client.getmaster())
        end,
        {description = "move to master", group = "client"}
        ),
    awful.key(
        {modkey},
        "o",
        function(c)
            c:move_to_screen()
        end,
        {description = "move to screen", group = "client"}
        ),
    awful.key(
        {modkey},
        "t",
        function(c)
            c.ontop = not c.ontop
        end,
        {description = "toggle keep on top", group = "client"}
        ),
    awful.key(
        {modkey},
        "n",
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        {description = "minimize", group = "client"}
        ),
    awful.key(
        {modkey},
        "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        {description = "maximize", group = "client"}
        ),
    awful.key(
        {modkey, "Control"},
        "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                client.focus = c
                c:raise()
            end
        end,
        {description = "restore minimized", group = "client"}
        )
    )

local desktopbuttons =
gears.table.join(
    awful.button(
        {},
        3,
        function()
            awful.util.mymainmenu:toggle()
        end
        )
    )
root.buttons(desktopbuttons)

local clientbuttons =
gears.table.join(
    awful.button(
        {},
        1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end
        ),
    awful.button(
        {modkey},
        1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.move(c)
        end
        ),
    awful.button(
        {modkey},
        3,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.resize(c)
        end
        )
    )

-- Bar setup
local spr = wibox.widget.textbox(" ")

-- Textclock
local clock =
awful.widget.watch(
    "date +'%a %m-%d %R %Z GMT'",
    60,
    function(widget, stdout)
        widget:set_markup(markup.font(beautiful.font, stdout))
    end
    )

-- Calendar
local cal =
lain.widget.cal(
    {
        attach_to = {clock},
        notification_preset = {
            font = beautiful.font,
            fg = beautiful.fg_normal,
            bg = beautiful.bg_normal
        }
    }
    )

-- Battery
local baticon = wibox.widget.imagebox(beautiful.widget_battery)
local bat = lain.widget.bat({
        settings = function()
            if bat_now.status and bat_now.status ~= "N/A" then
                if bat_now.ac_status == 1 then
                    baticon:set_image(beautiful.widget_ac)
                elseif not bat_now.perc and tonumber(bat_now.perc) <= 5 then
                    baticon:set_image(beautiful.widget_battery_empty)
                elseif not bat_now.perc and tonumber(bat_now.perc) <= 15 then
                    baticon:set_image(beautiful.widget_battery_low)
                else
                    baticon:set_image(beautiful.widget_battery)
                end
                if tonumber(bat_now.perc)==100 then
                    widget:set_markup(markup.font(beautiful.font, "Full"))
                else
                    widget:set_markup(markup.font(beautiful.font, bat_now.perc .. "%"))
                end
            else
                widget:set_markup(markup.font(beautiful.font, "AC"))
                baticon:set_image(beautiful.widget_ac)
            end
        end
    })

-- ALSA volume
local volicon = wibox.widget.imagebox(beautiful.widget_vol)
local volume = lain.widget.alsa({
        settings = function()
            if volume_now.status == "off" then
                volicon:set_image(beautiful.widget_vol_mute)
            elseif tonumber(volume_now.level) == 0 then
                volicon:set_image(beautiful.widget_vol_no)
            elseif tonumber(volume_now.level) <= 50 then
                volicon:set_image(beautiful.widget_vol_low)
            else
                volicon:set_image(beautiful.widget_vol)
            end

            widget:set_markup(markup.font(beautiful.font,volume_now.level .. "%"))
        end
    })
volume.widget:buttons(
    gears.table.join(
        awful.button(
            {},
            1,
            function()
                awful.spawn(apps.audiocontrol)
            end
            ),
        awful.button(
            {},
            3,
            function()
                awful.spawn(apps.bluetooth)
            end
            ),
        awful.button(
            {},
            4,
            function()
                awful.spawn("amixer set Master 1%+")
                volume.update()
            end
            ),
        awful.button(
            {},
            5,
            function()
                awful.spawn("amixer set Master 1%-")
                volume.update()
            end
            )
        )
    )

awful.screen.connect_for_each_screen(
    function(s)
        awful.tag(awful.util.tagnames, s, awful.layout.layouts)
        s.quake =
        lain.util.quake(
            {
                app = "termite",
                height = 0.43,
                width = 0.43,
                vert = "center",
                horiz = "center",
                followtag = true,
                argname = "--name %s"
            }
            )
        -- Create an imagebox widget which will contains an icon indicating which layout we're using.
        -- We need one layoutbox per screen.
        s.mylayoutbox = awful.widget.layoutbox(s)
        s.mylayoutbox:buttons(gears.table.join(
                awful.button({}, 1, function () awful.layout.inc( 1) end),
                awful.button({}, 3, function () awful.layout.inc(-1) end),
                awful.button({}, 4, function () awful.layout.inc( 1) end),
            awful.button({}, 5, function () awful.layout.inc(-1) end)))

            -- Create a taglist widget
            s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

            -- Create a tasklist widget
            s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

            -- Create the wibox
            s.mywibox = awful.wibar({position = "top", screen = s, height = beautiful.menu_height})

            -- Add widgets to the wibox
            s.mywibox:setup {
                layout = wibox.layout.align.horizontal,
                {
                    -- Left widgets
                    layout = wibox.layout.fixed.horizontal,
                    s.mytaglist
                },
                {
                    -- Middle widgets
                    layout = wibox.layout.fixed.horizontal,
                    -- s.mytasklist
                },
                {
                    -- Right widgets
                    layout = wibox.layout.fixed.horizontal,
                    wibox.widget.systray(),
                    -- spr,
                    volicon,
                    volume.widget,
                    spr,
                    baticon,
                    bat.widget,
                    spr,
                    clock,
                    spr,
                    s.mylayoutbox
                }
            }
        end
        )

    -- No borders when rearranging only 1 non-floating or maximized client
    screen.connect_signal(
        "arrange",
        function(s)
            local only_one = #s.tiled_clients == 1
            for _, c in pairs(s.clients) do
                if only_one and not c.floating or c.maximized then
                    c.border_width = 0
                else
                    c.border_width = beautiful.border_width
                end
            end
        end
        )

    -- Signal function to execute when a new client appears.
    client.connect_signal(
        "manage",
        function(c)
            -- Set the windows at the slave,
            -- i.e. put it at the end of others instead of setting it master.
            -- if not awesome.startup then awful.client.setslave(c) end

            if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
                -- Prevent clients from being unreachable after screen count changes.
                awful.placement.no_offscreen(c)
            end
        end
        )

    -- Enable sloppy focus, so that focus follows mouse.
    -- client.connect_signal(
    --     "mouse::enter",
    --     function(c)
    --         c:emit_signal("request::activate", "mouse_enter", {raise = vi_focus})
    --     end
    --     )

    -- ===================================================================
    -- Keys
    -- ===================================================================

    -- Menu
    local myawesomemenu = {
        {"restart", awesome.restart},
        {
            "quit",
            function()
                awesome.quit()
            end
        },
        {"sleep", sleep, beautiful.sleep},
        {"reboot", reboot, beautiful.reboot},
        {"poweroff", poweroff, beautiful.poweroff}
    }
    awful.util.mymainmenu =
    freedesktop.menu.build(
        {
            icon_size = beautiful.menu_height or dpi(16),
            before = {{"Awesome", myawesomemenu, beautiful.awesome_icon}},
            after = {{"Open terminal", apps.terminal}}
        }
        )
    -- }}}

    -- {{{ Key bindings
    local globalkeys =
    gears.table.join(
        -- Showing menu
        awful.key(
            {modkey},
            "w",
            function()
                awful.util.mymainmenu:show()
            end,
            {description = "show main menu", group = "awesome"}
            ),
        -- Hotkeys
        awful.key({modkey}, "s", hotkeys_popup.show_help, {description = "show help", group = "awesome"}),
        -- Dropdown application
        awful.key(
            {modkey},
            "z",
            function()
                awful.screen.focused().quake:toggle()
            end,
            {description = "dropdown application", group = "launcher"}
            ),
        -- Default client focus
        awful.key(
            {altkey, "Shift"},
            "j",
            function()
                awful.client.focus.byidx(1)
            end,
            {description = "focus next by index", group = "client"}
            ),
        awful.key(
            {altkey, "Shift"},
            "k",
            function()
                awful.client.focus.byidx(-1)
            end,
            {description = "focus previous by index", group = "client"}
            ),
        -- Layout manipulation
        awful.key(
            {modkey, "Shift"},
            "h",
            function()
                awful.client.swap.byidx(1)
            end,
            {description = "swap with next client by index", group = "client"}
            ),
        awful.key(
            {modkey, "Shift"},
            "l",
            function()
                awful.client.swap.byidx(-1)
            end,
            {description = "swap with previous client by index", group = "client"}
            ),
        -- Switch between screens
        awful.key(
            {modkey, "Control"},
            "j",
            function()
                awful.screen.focus_relative(1)
            end,
            {description = "focus the next screen", group = "screen"}
            ),
        awful.key(
            {modkey, "Control"},
            "k",
            function()
                awful.screen.focus_relative(-1)
            end,
            {description = "focus the previous screen", group = "screen"}
            ),
        -- On the fly useless gaps change
        awful.key(
            {modkey, "Control"},
            "-",
            function()
                lain.util.useless_gaps_resize(5)
            end,
            {description = "increment useless gaps", group = "tag"}
            ),
        awful.key(
            {modkey},
            "-",
            function()
                lain.util.useless_gaps_resize(-5)
            end,
            {description = "decrement useless gaps", group = "tag"}
            ),
        -- Standard program
        awful.key(
            {"Shift", altkey},
            "t",
            function()
                awful.spawn("alacritty")
            end,
            {description = "open a terminal", group = "launcher"}
            ),
        awful.key(
            {"Control", altkey},
            "t",
            function()
                awful.spawn("kitty")
            end,
            {description = "open a kitty", group = "launcher"}
            ),
        -- User programs
        awful.key(
            {modkey},
            "p",
            function()
                awful.spawn(apps.screenshot)
            end,
            {description = "take a screenshot", group = "hotkeys"}
            ),
        awful.key(
            {altkey, "Control"},
            "e",
            function()
                awful.spawn("./.dmenu/dmenu-edit-conf.sh")
            end,
            {description = "edit config files", group = "dmenu scripts"}
            ),
        awful.key(
            {modkey},
            "b",
            function()
                awful.spawn(apps.browser)
            end,
            {description = "run Firefox", group = "launcher"}
            ),
        awful.key(
            {modkey},
            "a",
            function()
                awful.spawn(apps.gui_editor)
            end,
            {description = "run gui editor", group = "launcher"}
            ),
        -- spotify
        awful.key(
            {modkey, "Shift"},
            "m",
            function()
                awful.spawn(apps.spotify)
            end,
            {description = "run spotify", group = "launcher"}
            ),
        -- file browser
        awful.key(
            {modkey, "Shift"},
            "f",
            function()
                awful.spawn(apps.filebrowser)
            end,
            {description = "run explorer", group = "launcher"}
            ),
        awful.key(
            {modkey, "Shift"},
            "z",
            function()
                awful.spawn(apps.zotero)
            end,
            {description = "run zotero", group = "launcher"}
            ),
        -- X screen locker
        awful.key(
            {"Control", altkey},
            "l",
            function()
                naughty.suspend()
                os.execute(apps.lock)
            end,
            {description = "lock screen", group = "hotkeys"}
            ),
        --rofi
        awful.key(
            {"Control"},
            "space",
            function()
                awful.spawn(apps.launcher)
            end,
            {description = "show rofi", group = "launcher"}
            ),
        -- Prompt
        awful.key(
            {modkey},
            "r",
            function()
                awful.screen.focused().mypromptbox:run()
            end,
            {description = "run prompt", group = "launcher"}
            ),
        awful.key({modkey, "Shift"}, "r", awesome.restart, {description = "reload awesome", group = "awesome"}),
        awful.key({modkey, "Shift"}, "q", awesome.quit, {description = "quit awesome", group = "awesome"}),
        -- layout chanages
        awful.key(
            {altkey, "Shift"},
            "l",
            function()
                awful.tag.incmwfact(0.05)
            end,
            {description = "increase master width factor", group = "layout"}
            ),
        awful.key(
            {altkey, "Shift"},
            "h",
            function()
                awful.tag.incmwfact(-0.05)
            end,
            {description = "decrease master width factor", group = "layout"}
            ),
        awful.key(
            {modkey, "Shift"},
            "k",
            function()
                awful.tag.incnmaster(1, nil, true)
            end,
            {description = "increase the number of master clients", group = "layout"}
            ),
        awful.key(
            {modkey, "Shift"},
            "j",
            function()
                awful.tag.incnmaster(-1, nil, true)
            end,
                -- screen = awful.screen.focused,
            {description = "decrease the number of master clients", group = "layout"}
            ),
        awful.key(
            {modkey, "Control"},
            "h",
            function()
                awful.tag.incncol(1, nil, true)
            end,
            {description = "increase the number of columns", group = "layout"}
            ),
        awful.key(
            {modkey, "Control"},
            "l",
            function()
                awful.tag.incncol(-1, nil, true)
            end,
            {description = "decrease the number of columns", group = "layout"}
            ),
        -- normal Alt-Tab behaviour
        awful.key(
            {altkey},
            "Tab",
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
            ),
        awful.key(
            {altkey, "Shift"},
            "Tab",
            function()
                if cycle_prev then
                    awful.client.focus.byidx(1)
                    if client.focus then
                        client.focus:raise()
                    end
                end
            end,
            {description = "go forth", group = "client"}
            ),

        -- awful.key({altkey}, "Tab", 
        --     function()
        --         switcher.switch(1, altkey, "Alt_L", "Shift", Tab)
        --     end),
        -- ALSA volume control
        awful.key(
            {},
            "XF86AudioRaiseVolume",
            function()
                os.execute(string.format("amixer -q set %s 2%%+", volume.channel))
                volume.update()
            end,
            {description = "volume up", group = "volume"}
            ),
        awful.key(
            {},
            "XF86AudioLowerVolume",
            function()
                os.execute(string.format("amixer -q set %s 2%%-", volume.channel))
                volume.update()
            end,
            {description = "volume down", group = "volume"}
            ),
        awful.key(
            {},
            "XF86AudioMute",
            function()
                os.execute(string.format("amixer -q set %s toggle", volume.togglechannel or volume.channel))
                volume.update()
            end,
            {description = "toggle mute", group = "volume"}
            ),
        awful.key(
            {altkey, "Control"},
            "Up",
            function()
                os.execute(string.format("amixer -q set %s 100%%", volume.channel))
                volume.update()
            end,
            {description = "volume 100%", group = "volume"}
            ),
        awful.key(
            {altkey, "Control"},
            "Down",
            function()
                os.execute(string.format("amixer -q set %s 0%%", volume.channel))
                volume.update()
            end,
            {description = "volume 0%", group = "volume"}
            )
        )

    -- Bind all key numbers to tags.
    -- Be careful: we use keycodes to make it works on any keyboard layout.
    -- This should map on the top row of your keyboard, usually 1 to 9.
    for i = 1, 9 do
        -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
        local descr_view, descr_toggle, descr_move, descr_toggle_focus
        if i == 1 or i == 9 then
            descr_view = {description = "view tag #", group = "tag"}
            descr_toggle = {description = "toggle tag #", group = "tag"}
            descr_move = {description = "move focused client to tag #", group = "tag"}
            descr_toggle_focus = {description = "toggle focused client on tag #", group = "tag"}
        end
        globalkeys =
        gears.table.join(
            globalkeys,
            -- View tag only.
            awful.key(
                {modkey},
                "#" .. i + 9,
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
            awful.key(
                {modkey, "Control"},
                "#" .. i + 9,
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
            awful.key(
                {modkey, "Shift"},
                "#" .. i + 9,
                function()
                    if client.focus then
                        local tag = client.focus.screen.tags[i]
                        if tag then
                            client.focus:move_to_tag(tag)
                        end
                    end
                end,
                descr_move
                ),
            -- Toggle tag on focused client.
            awful.key(
                {modkey, "Control", "Shift"},
                "#" .. i + 9,
                function()
                    if client.focus then
                        local tag = client.focus.screen.tags[i]
                        if tag then
                            client.focus:toggle_tag(tag)
                        end
                    end
                end,
                descr_toggle_focus
                )
            )
    end
    -- global keys
    root.keys(globalkeys)

    -- switcher settings
    switcher.settings.preview_box                        = true                                     -- display preview-box
    switcher.settings.preview_box_bg                     = "#ddddddaa"                              -- background color
    switcher.settings.preview_box_border                 = "#22222200"                              -- border-color
    switcher.settings.preview_box_fps                    = 30                                       -- refresh framerate
    switcher.settings.preview_box_delay                  = 150                                      -- delay in ms
    switcher.settings.preview_box_title_font             = {"mononoki Nerd Font","italic","normal"} -- the font for cairo
    switcher.settings.preview_box_title_font_size_factor = 1                                        -- the font sizing factor
    switcher.settings.client_opacity                     = false                                    -- opacity for unselected clients
    switcher.settings.client_opacity_value               = 0.5                                      -- alpha-value for any client
    switcher.settings.client_opacity_value_in_focus      = 0.5                                      -- alpha-value for the client currently in focus
    switcher.settings.client_opacity_value_selected      = 1                                        -- alpha-value for the selected client
    switcher.settings.cycle_raise_client                 = true                                     -- raise clients on cycle

    -- ===================================================================
    -- Rules setup
    -- ===================================================================

    awful.rules.rules = {
        -- All clients will match this rule.
        {
            rule = {},
            properties = {
                border_width = beautiful.border_width,
                border_color = beautiful.border_normal,
                focus = awful.client.focus,
                raise = true,
                keys = clientkeys,
                buttons = clientbuttons,
                placement = awful.placement.no_overlap + awful.placement.no_offscreen,
                size_hints_honor = false
            }
        },
        -- Floating clients.
        {
            rule_any = {
                instance = {
                    "DTA",
                    "copyq",
                    "nvidia-settings",
                    "blueman-services",
                    "blueman-adapters",
                    "galculator",
                    "baobab",
                    "xmessage",
                    "skype",
                    "chatterino",
                    "lxappearance",
                    "zoom",
                    "gparted",
                    "qt5ct",
                    "kvantum",
                    "grub-customizer"
                },
                class = {
                    "Nm-connection-editor",
                    "gnome-disks",
                    "Thunar",
                    "Arandr",
                    "Zotero",
                    "Blueman-manager",
                    "Pavucontrol",
                    "Pcmanfm",
                    "Nitrogen",
                    "Termite",
                },
                name = {
                    "Library",
                    "Chat",
                    "Event Tester",
                    "Settings"
                },
                type = {"dialog", "popup"}
            },
            properties = {{floating = true}}
        },
        {
            rule_any = {class = {"spotify","Vmware"}, instance={"kdocker"}},
            properties = {screen=screen.count()>1 and 2 or 1,tag = awful.util.tagnames[2], switchtotag=true}
        },
        {
            rule = {class = "kitty"},
            properties = {screen=screen.count()>1 and 2 or 1,tag = awful.util.tagnames[6], switchtotag = true}
        },
        {
            rule_any = {class = {"Lutris","Steam", "minecraft-launcher"}},
            properties = { switchtotag = true, screen=screen.count()>1 and 2 or 1,tag = awful.util.tagnames[5]}
        },
        {
            rule_any = {instance={"chromium","firefox"}},
            properties = {screen=1, tag = awful.util.tagnames[3], switchtotag = true}
        },
        {
            rule_any = {
                class="Microsoft Teams - Preview", 
                instance = {"zoom", "discord", "slack", "skype","caprine"}
            },
            properties = {screen=screen.count()>1 and 2 or 1, tag = awful.util.tagnames[4], switchtotag = true}
        },
        {rule = {class = "Gimp"}, properties = {maximized = true}},
        -- Rofi
        {rule = {instance = "rofi"}, properties = {maximized = false, ontop = true}},
        {rule = {instance = "termite"}, properties = {maximized = false, ontop = true, floating = true}},
        -- File chooser dialog
        {
            rule_any = {role = "GtkFileChooserDialog"},
            properties = {floating = true, width = screen_width * 0.55, height = screen_height * 0.65}
        }
    }

    -- ===================================================================
    -- Garbage collection (allows for lower memory consumption)
    -- ===================================================================

    collectgarbage("setpause", 110)
    collectgarbage("setstepmul", 1000)

    client.connect_signal(
        "focus",
        function(c)
            c.border_color = beautiful.border_focus
        end
        )
    client.connect_signal(
        "unfocus",
        function(c)
            c.border_color = beautiful.border_normal
        end
        )

    awful.spawn.with_shell("~/.config/awesome/autorun.sh")
