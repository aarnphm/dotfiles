-- Bufferline
--
local vis = {guifg = '#eaeaea', guibg = '#131a21', gui = ''}
local sel = {guifg = "#eaeaea", guibg = '#29343d', gui = ''}

require'bufferline'.setup {
    options = {
        view = "default",
        numbers = "none",
        -- diagnostics = "nvim_lsp",
        buffer_close_icon = '',
        modified_icon = '●',
        show_close_icon = false,
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        max_name_length = 18,
        max_prefix_length = 15,
        tab_size = 18,
        show_buffer_close_icons = false,
        persist_buffer_sort = true,
        always_show_bufferline = true
    },
    highlights = {
        buffer_visible = vis,
        buffer_selected = sel,
        modified = vis,
        modified_visible = vis,
        modified_selected = sel,
        background = vis,
        fill = {guibg = '#131a21'},
        indicator_selected = {guibg = '#9ce5c0'},
        separator = {guibg = '#131a21', guifg = '#29343d'}
    }
}
