-- Galaxyline
--
local gl = require('galaxyline')
local gls = gl.section
local condition = require('galaxyline.condition')
gl.short_line_list = {'NvimTree', 'vista', 'dbui', 'packer'}

local colors = {
    bg0 = '#131a21',
    bg = '#29343d',
    bg1 = '#3b4b58',
    fg = '#bbc2cf',
    yellow = '#fbdf90',
    cyan = '#9ce5c0',
    darkblue = '#a3b8ef',
    green = '#7ed491',
    orange = '#fbeab9',
    violet = '#ccaced',
    magenta = '#a3b8ef',
    blue = '#a3b8ef',
    red = '#f9929b'
}

local function lsp_status(status)
    shorter_stat = ''
    for match in string.gmatch(status, "[^%s]+") do
        err_warn = string.find(match, "^[WE]%d+", 0)
        if not err_warn then shorter_stat = shorter_stat .. ' ' .. match end
    end
    return shorter_stat
end

local function trailing_whitespace()
    local trail = vim.fn.search("\\s$", "nw")
    if trail ~= 0 then
        return ' '
    else
        return nil
    end
end

local TrailingWhiteSpace = trailing_whitespace

local buffer_not_empty = function()
    if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then return true end
    return false
end

gls.left[1] = {
    ViMode = {
        provider = function()
            -- auto change color according the vim mode
            local mode_color = {
                n = colors.magenta,
                i = colors.green,
                v = colors.blue,
                [''] = colors.blue,
                v = colors.blue,
                c = colors.red,
                no = colors.magenta,
                s = colors.orange,
                s = colors.orange,
                [''] = colors.orange,
                ic = colors.yellow,
                R = colors.violet,
                Rv = colors.violet,
                cv = colors.red,
                ce = colors.red,
                r = colors.cyan,
                rm = colors.cyan,
                ['r?'] = colors.cyan,
                ['!'] = colors.red,
                t = colors.red
            }
            vim.api.nvim_command('hi GalaxyViMode guibg=' ..
                                     mode_color[vim.fn.mode()])
            return '   '
        end,
        separator = ' ',
        separator_highlight = {'NONE', colors.bg},
        highlight = {colors.bg1, colors.red, 'bold'}
    }
}

gls.left[2] = {
    FileIcon = {
        provider = 'FileIcon',
        condition = buffer_not_empty,
        highlight = {
            require('galaxyline.provider_fileinfo').get_file_icon_color,
            colors.bg
        }
    }
}

gls.left[3] = {
    FileName = {
        provider = {'FileName'},
        condition = buffer_not_empty,
        highlight = {colors.cyan, colors.bg, 'bold'}
    }
}

gls.left[4] = {
    LineInfo = {
        provider = 'LineColumn',
        separator = ' ',
        separator_highlight = {'NONE', colors.bg},
        highlight = {colors.fg, colors.bg}
    }
}

gls.left[5] = {
    PerCent = {
        provider = 'LinePercent',
        separator = ' ',
        separator_highlight = {'NONE', colors.bg},
        highlight = {colors.fg, colors.bg, 'bold'}
    }
}

gls.left[6] = {
    RainbowBlue = {
        provider = function() return '▊' end,
        highlight = {colors.blue, colors.bg}
    }
}

gls.left[7] = {
    DiagnosticError = {
        provider = 'DiagnosticError',
        icon = '  ',
        highlight = {colors.red, colors.bg0}
    }
}
gls.left[8] = {
    DiagnosticWarn = {
        provider = 'DiagnosticWarn',
        icon = '   ',
        highlight = {colors.yellow, colors.bg0}
    }
}

gls.left[9] = {
    DiagnosticHint = {
        provider = 'DiagnosticHint',
        icon = '   ',
        highlight = {colors.cyan, colors.bg0}
    }
}

gls.left[10] = {
    DiagnosticInfo = {
        provider = 'DiagnosticInfo',
        icon = '  ',
        highlight = {colors.blue, colors.bg0}
    }
}

gls.right[1] = {
    RainbowBlue = {
        provider = function() return '▊' end,
        highlight = {colors.blue, colors.bg}
    }
}

gls.right[2] = {
    FileEncode = {
        provider = 'FileEncode',
        separator = ' ',
        icon = ' ',
        separator_highlight = {'NONE', colors.bg},
        highlight = {colors.cyan, colors.bg, 'bold'}
    }
}

gls.right[3] = {
    FileFormat = {
        provider = 'FileFormat',
        separator = ' ',
        separator_highlight = {'NONE', colors.bg},
        highlight = {colors.cyan, colors.bg, 'bold'}
    }
}

gls.right[4] = {
    GitIcon = {
        provider = function() return '  ' end,
        condition = require('galaxyline.provider_vcs').check_git_workspace,
        separator = ' ',
        separator_highlight = {'NONE', colors.bg},
        highlight = {colors.violet, colors.bg, 'bold'}
    }
}

gls.right[5] = {
    GitBranch = {
        provider = 'GitBranch',
        condition = require('galaxyline.provider_vcs').check_git_workspace,
        highlight = {colors.violet, colors.bg, 'bold'}
    }
}

local checkwidth = function()
    local squeeze_width = vim.fn.winwidth(0) / 2
    if squeeze_width > 40 then return true end
    return false
end

gls.right[6] = {
    DiffAdd = {
        provider = 'DiffAdd',
        condition = checkwidth,
        icon = '  ',
        highlight = {colors.green, colors.bg}
    }
}
gls.right[7] = {
    DiffModified = {
        provider = 'DiffModified',
        condition = checkwidth,
        icon = ' | ',
        highlight = {colors.orange, colors.bg}
    }
}
gls.right[8] = {
    DiffRemove = {
        provider = 'DiffRemove',
        condition = checkwidth,
        icon = '  ',
        highlight = {colors.red, colors.bg}
    }
}

gls.right[9] = {
    RainbowBlue = {
        provider = function() return '  ▊' end,
        highlight = {colors.blue, colors.bg}
    }
}

gls.short_line_left[1] = {
    BufferType = {
        provider = 'FileTypeName',
        separator = ' ',
        separator_highlight = {'NONE', colors.bg0},
        highlight = {colors.blue, colors.bg0, 'bold'}
    }
}

gls.short_line_right[1] = {
    SFileName = {
        provider = 'SFileName',
        condition = condition.buffer_not_empty,
        highlight = {colors.fg, colors.bg0, 'bold'}
    }
}
