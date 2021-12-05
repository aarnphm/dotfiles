local wezterm = require('wezterm')
local mytable = require("lib/mystdlib").mytable
local theme = require('theme')
local configuration = require('configuration')

function font_with_fallback(name, params)
    local names = {name, "FiraCode Nerd Font Mono", "Blobmoji"}
    return wezterm.font_with_fallback(names, params)
end

local cfg_misc = {
    -- OpenGL for GPU acceleration, Software for CPU
    front_end = "OpenGL",

    -- No updates, bleeding edge only
    check_for_updates = false,

    -- Font Stuff
    font = font_with_fallback("Inconsolata"),
    font_rules = {
        {
            italic = true,
            font = font_with_fallback("Inconsolata", {italic = true})
        }, {
            italic = true,
            intensity = "Bold",
            font = font_with_fallback("Inconsolata",
                                      {bold = true, italic = true})
        },
        {
            intensity = "Bold",
            font = font_with_fallback("Inconsolata", {bold = true})
        },
        {intensity = "Half", font = font_with_fallback("Inconsolata")}
    },
    font_size = 18.0,
    font_shaper = "Harfbuzz",
    line_height = 1.0,
    freetype_load_target = "HorizontalLcd",
    freetype_render_target = "HorizontalLcd",

    -- Cursor style
    default_cursor_style = "SteadyUnderline",

    -- X Bad
    enable_wayland = false,

    -- Pretty Colors
    bold_brightens_ansi_colors = true,

    -- Get rid of close prompt
    window_close_confirmation = "NeverPrompt",

    -- Padding
    -- Top is offsetted for titlebar
    window_padding = {left = 50, right = 50, top = 50, bottom = 50},

    -- No opacity
    inactive_pane_hsb = {saturation = 1.0, brightness = 1.0},
    default_prog = {"/bin/zsh", "-c", "tmux"},
}

-- Colors
local cfg_colors = {colors = theme.colors}

-- Tab Style (like shape)
local cfg_tab_bar = configuration.tabs

-- Keys
local cfg_keys = configuration.keys

-- Merge everything and return
local config = mytable.merge_all(cfg_misc, cfg_colors, cfg_tab_bar,
                                 cfg_keys)
return config
