vim.g.bufferline = {
   -- Enable/disable animations
   animation = true,

   -- Enable/disable auto-hiding the tab bar when there is a single buffer
   auto_hide = false,

   -- Enable/disable current/total tabpages indicator (top right corner)
   tabpages = true,

   -- Enable/disable close button
   closable = true,

   -- Enables/disable clickable tabs
   --  - left-click: go to buffer
   --  - middle-click: delete buffer
   clickable = true,

   -- Excludes buffers from the tabline
   exclude_ft = { "javascript" },
   exclude_name = { "package.json" },

   -- Enable/disable icons
   -- if set to 'numbers', will show buffer index in the tabline
   -- if set to 'both', will show buffer index and icons in the tabline
   icons = true,

   -- If set, the icon color will follow its corresponding buffer
   -- highlight group. By default, the Buffer*Icon group is linked to the
   -- Buffer* group (see Highlighting below). Otherwise, it will take its
   -- default value as defined by devicons.
   icon_custom_colors = false,

   -- Configure icons on the bufferline.
   icon_separator_active = "▎",
   icon_separator_inactive = "▎",
   icon_close_tab = "",
   icon_close_tab_modified = "●",
   icon_pinned = "車",

   -- If true, new buffers will be inserted at the start/end of the list.
   -- Default is to insert after current buffer.
   insert_at_end = false,
   insert_at_start = false,

   -- Sets the maximum padding width with which to surround each tab
   maximum_padding = 1,

   -- Sets the maximum buffer name length.
   maximum_length = 30,

   -- If set, the letters for each buffer in buffer-pick mode will be
   -- assigned based on their name. Otherwise or in case all letters are
   -- already assigned, the behavior is to assign letters in order of
   -- usability (see order below)
   semantic_letters = true,

   -- New buffer letters are assigned in this order. This order is
   -- optimal for the qwerty keyboard layout but might need adjustement
   -- for other layouts.
   letters = "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP",

   -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
   -- where X is the buffer number. But only a static string is accepted here.
   no_name_title = nil,
}

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next
map("n", "<C-i>", ":BufferPrevious<CR>", opts)
map("n", "<C-o>", ":BufferNext<CR>", opts)
-- Re-order to previous/next
map("n", "<A-<>", ":BufferMovePrevious<CR>", opts)
map("n", "<A->>", " :BufferMoveNext<CR>", opts)
-- Goto buffer in position...
map("n", "1gt", ":BufferGoto 1<CR>", opts)
map("n", "2gt", ":BufferGoto 2<CR>", opts)
map("n", "3gt", ":BufferGoto 3<CR>", opts)
map("n", "4gt", ":BufferGoto 4<CR>", opts)
map("n", "5gt", ":BufferGoto 5<CR>", opts)
map("n", "6gt", ":BufferGoto 6<CR>", opts)
map("n", "7gt", ":BufferGoto 7<CR>", opts)
map("n", "8gt", ":BufferGoto 8<CR>", opts)
map("n", "9gt", ":BufferGoto 9<CR>", opts)
map("n", "0gt", ":BufferLast<CR>", opts)
