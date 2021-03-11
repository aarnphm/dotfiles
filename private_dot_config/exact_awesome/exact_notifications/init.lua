local naughty       = require("naughty")
local beautiful     = require("beautiful")
local wibox         = require("wibox")
local awful         = require("awful")
local helpers       = require("helpers")
local ruled         = require("ruled")
local menubar       = require("menubar")
local dpi           = beautiful.xresources.apply_dpi

require("notifications.volume")

naughty.config.defaults.ontop        = true
naughty.config.defaults.screen       = awful.screen.focused()
naughty.config.defaults.timeout      = 2
naughty.config.defaults.border_color = x.foreground
naughty.config.padding               = dpi(10)
naughty.config.spacing               = dpi(5)
naughty.config.icon_dirs             = {"/usr/share/icons/Papirus-Dark/24x24/apps/", "/usr/share/pixmaps/"}
naughty.config.icon_formats          = {"png", "svg"}

-- Timeouts
naughty.config.presets.low.timeout      = 3
naughty.config.presets.critical.timeout = 0

naughty.config.presets.normal = {
    font = beautiful.font,
    fg = beautiful.fg_normal,
    bg = beautiful.bg_normal
}

naughty.config.presets.low = {
    font = beautiful.font,
    fg = beautiful.fg_normal,
    bg = beautiful.bg_normal
}

naughty.config.presets.critical = {
    font = beautiful.fontname .. "10",
    fg = x.color1,
    bg = beautiful.bg_normal,
    timeout = 0
}

naughty.config.presets.ok = naughty.config.presets.normal
naughty.config.presets.info = naughty.config.presets.normal
naughty.config.presets.warn = naughty.config.presets.critical

ruled.notification.connect_signal('request::rules', function()
    -- All notifications will match this rule.
    ruled.notification.append_rule {
        rule = {},
        properties = {screen = awful.screen.preferred, implicit_timeout=2}
    }
end)

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notify {
        urgency = "critical",
        title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
        message = message,
        app_name = 'System Notification',
        icon = beautiful.awesome_icon
    }
end)

-- XDG icon lookup
naughty.connect_signal(
    'request::icon',
    function(n, context, hints)
        if context ~= 'app_icon' then return end

        local path = menubar.utils.lookup_icon(hints.app_icon) or
        menubar.utils.lookup_icon(hints.app_icon:lower())

        if path then
            n.icon = path
        end
    end
    )

-- Use XDG icon
naughty.connect_signal("request::action_icon", function(a, context, hints)
    a.icon = menubar.utils.lookup_icon(hints.id)
end)

naughty.connect_signal("request::display", function(n)
    local appicon = n.icon or n.app_icon

    local action_widget = {
        {
            {
                id = 'text_role',
                align = "center",
                valign = "center",
                font = beautiful.fontname .. "8",
                widget = wibox.widget.textbox
            },
            left = dpi(6),
            right = dpi(6),
            widget = wibox.container.margin
        },
        bg = x.color0,
        shape = helpers.rrect(dpi(4)),
        widget = wibox.container.background
    }

    local actions = wibox.widget {
        notification = n,
        base_layout  = wibox.widget {
            spacing = dpi(8),
            layout  = wibox.layout.flex.horizontal
        },
        widget_template = action_widget,
        style           = {underline_normal = false, underline_selected = true},
        widget          = naughty.list.actions
    }

    naughty.layout.box {
        notification = n,
        type            = "notification",
        widget_template = {
            {
                {
                    {
                        {
                            {
                                {
                                    {
                                        {
                                            image = appicon,
                                            resize = true,
                                            clip_shape = helpers.rrect(beautiful.border_radius - 3),
                                            widget = wibox.widget.imagebox
                                        },
                                        bg = x.color1,
                                        strategy = 'max',
                                        height = dpi(40),
                                        width = dpi(40),
                                        widget = wibox.container.constraint
                                    },
                                    layout = wibox.layout.align.vertical
                                },
                                top = dpi(10),
                                left = dpi(15),
                                right = dpi(15),
                                bottom = dpi(10),
                                widget = wibox.container.margin
                            },
                            {
                                {
                                    nil,
                                    {
                                        {
                                            step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
                                            speed = 50,
                                            {
                                                markup = "<span weight='bold'>" .. n.title .. "</span>",
                                                font = beautiful.font,
                                                align = "left",
                                                widget = wibox.widget.textbox
                                            },
                                            forced_width = beautiful.notification_width or dpi(220),
                                            widget = wibox.container.scroll.horizontal
                                        },
                                        {
                                            step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
                                            speed = 100,
                                            {
                                                markup = n.message,
                                                font = beautiful.font,
                                                align = "left",
                                                widget = wibox.widget.textbox
                                            },
                                            forced_width = beautiful.notification_width or dpi(220),
                                            widget = wibox.container.scroll.horizontal
                                        },
                                        {
                                            actions,
                                            visible = n.actions and #n.actions > 0,
                                            layout = wibox.layout.fixed.vertical,
                                            forced_width = dpi(220)
                                        },
                                        -- spacing = dpi(3),
                                        layout = wibox.layout.fixed.vertical
                                    },
                                    nil,
                                    expand = "none",
                                    layout = wibox.layout.align.vertical
                                },
                                margins = dpi(8),
                                widget = wibox.container.margin
                            },
                            layout = wibox.layout.fixed.horizontal
                        },
                        top = dpi(10),
                        bottom = dpi(10),
                        widget = wibox.container.margin
                    },
                    bg = x.background,
                    shape = helpers.rrect(beautiful.border_radius),
                    widget = wibox.container.background
                },
                margins = beautiful.widget_border_width,
                widget = wibox.container.margin
            },
            bg = "#00000000",
            shape = helpers.rrect(beautiful.border_radius),
            widget = wibox.container.background
        }
    }
end)

function notify_dwim(args, notification)
    local n = notification
    if n and not n._private.is_destroyed and not n.is_expired then
        notification.title = args.title or notification.title
        notification.message = args.message or notification.message
        -- notification.text = args.text or notification.text
        notification.icon = args.icon or notification.icon
        notification.timeout = args.timeout or notification.timeout
    else
        n = naughty.notify(args)
    end
    return n
end
