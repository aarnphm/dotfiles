local M = {}

M.plugin = {
   "nvim-telescope/telescope.nvim",
   module_pattern = { "telescope", "telescope.*" },
   cmd = "Telescope",
   keys = {
      { "", "<C-p>" },
      { "", "<C-f>" },
      { "n", "<Leader>f" },
   },
   wants = {
      "popup.nvim",
      "plenary.nvim",
      "telescope-fzf-native.nvim",
      "telescope-frecency.nvim",
      "telescope-ui-select.nvim",
   },
   requires = {
      "nvim-telescope/telescope-frecency.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
   },
   config = function()
      require("plugins.telescope").config()
   end,
}

M.config = function()
   local _, telescope = pcall(require, "telescope")
   local actions = require "telescope.actions"
   local previewers = require "telescope.previewers"

   local k = vim.keymap
   local nnoremap = k.nnoremap

   M.no_preview = function(opts)
      return vim.tbl_extend(
         "force",
         require("telescope.themes").get_dropdown {
            borderchars = {
               { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
               prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
               results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
               preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
            },
            layout_config = {
               width = 0.6,
            },
            previewer = false,
         },
         opts or {}
      )
   end

   telescope.setup {
      defaults = {
         file_previewer = previewers.vim_buffer_cat.new,
         grep_previewer = previewers.vim_buffer_vimgrep.new,
         qflist_previewer = previewers.vim_buffer_qflist.new,
         scroll_strategy = "cycle",
         selection_strategy = "reset",
         layout_strategy = "flex",
         borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
         layout_config = {
            horizontal = {
               width = 0.8,
               height = 0.8,
               preview_width = 0.6,
            },
            vertical = {
               height = 0.8,
               preview_height = 0.5,
            },
         },
         mappings = {
            i = {
               ["<C-j>"] = actions.move_selection_next,
               ["<C-k>"] = actions.move_selection_previous,

               ["<C-v>"] = actions.select_vertical,
               ["<C-x>"] = actions.select_horizontal,
               ["<C-t>"] = actions.select_tab,

               ["<C-c>"] = actions.close,
               -- ["<Esc>"] = actions.close,

               ["<C-u>"] = actions.preview_scrolling_up,
               ["<C-d>"] = actions.preview_scrolling_down,
               ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
               ["<Tab>"] = actions.toggle_selection,
               -- ["<C-r>"] = actions.refine_result,
            },
            n = {
               ["<CR>"] = actions.select_default + actions.center,
               ["<C-v>"] = actions.select_vertical,
               ["<C-x>"] = actions.select_horizontal,
               ["<C-t>"] = actions.select_tab,
               ["<Esc>"] = actions.close,

               ["j"] = actions.move_selection_next,
               ["k"] = actions.move_selection_previous,

               ["<C-u>"] = actions.preview_scrolling_up,
               ["<C-d>"] = actions.preview_scrolling_down,
               ["<C-q>"] = actions.send_to_qflist,
               ["<Tab>"] = actions.toggle_selection,
            },
         },
      },
      pickers = {
         grep_string = {
            file_ignore_patterns = {
               "%.png",
               "%.jpg",
               "%.webp",
               "node_modules",
               "*%.min%.*",
               "dotbot",
            },
         },
         find_files = {
            file_ignore_patterns = {
               "%.png",
               "%.jpg",
               "%.webp",
               "node_modules",
               "*%.min%.*",
               "dotbot",
            },
         },
         lsp_code_actions = M.no_preview(),
         current_buffer_fuzzy_find = M.no_preview(),
      },
      extensions = {
         ["ui-select"] = M.no_preview(),
         fzf = {
            override_generic_sorter = true,
            override_file_sorter = true,
         },
         frecency = {
            show_scores = true,
            show_unindexed = true,
            devicons_disabled = true,
            ignore_patterns = { "*.git/*", "*/tmp/*" },
            workspaces = {
               ["nvim"] = "/home/aarnphm/.config/nvim",
               ["awesome"] = "/home/aarnphm/.config/awesome",
            },
         },
      },
   }

   telescope.load_extension "fzf" -- Sorter using fzf algorithm
   telescope.load_extension "frecency" -- Frecency algorithm
   telescope.load_extension "ui-select" -- vim.ui.select

   M.arecibo = function()
      telescope.extensions.arecibo.websearch(M.no_preview())
   end

   M.frecency = function()
      telescope.extensions.frecency.frecency(M.no_preview())
   end

   M.project = function()
      telescope.extensions.project.project(M.no_preview { display_type = "full" })
   end

   M.builtins = function()
      require("telescope.builtin").builtin(M.no_preview())
   end

   M.workspace_symbols = function()
      require("telescope.builtin").lsp_workspace_symbols {
         path_display = { "absolute" },
      }
   end

   M.grep_prompt = function()
      require("telescope.builtin").grep_string {
         path_display = { "shorten" },
         search = vim.fn.input "Grep String > ",
         only_sort_text = true,
         use_regex = true,
      }
   end

   -- toggle telescope.nvim
   nnoremap {
      "<C-p>",
      require("telescope.builtin").find_files,
      { silent = true },
   }
   nnoremap { "<C-f>", M.grep_prompt, { silent = true } }
   nnoremap { "<Leader>ft", M.builtins, { silent = true } }
   nnoremap { "<Leader>ff", M.frecency, { silent = true } }
   nnoremap { "<Leader>fa", M.arecibo, { silent = true } }
   nnoremap { "<Leader>fls", M.workspace_symbols, { silent = true } }
   nnoremap {
      "<Leader>fb",
      require("telescope.builtin").current_buffer_fuzzy_find,
      { silent = true },
   }
   nnoremap { "<Leader>fp", M.project, { silent = true } }
end

return M