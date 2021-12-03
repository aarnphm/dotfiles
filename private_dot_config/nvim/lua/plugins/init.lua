local packer_ok, packer = pcall(require, "packer")
if not packer_ok then
   return
end

return packer.startup {
   {
      { "wbthomason/packer.nvim", opt = true },

      { "lewis6991/impatient.nvim" },

      { "dstein64/vim-startuptime", cmd = "StartupTime" },

      { "nathom/filetype.nvim" },

      { "wakatime/vim-wakatime" },

      { "tpope/vim-surround" },
      { "tpope/vim-commentary" },
      { "tpope/vim-vinegar" },
      { "tpope/vim-apathy" },
      { "tpope/vim-sleuth" },
      { "tpope/vim-fugitive" },
      { "thaerkh/vim-indentguides" },
      {
         "christoomey/vim-tmux-navigator",
         config = function()
            vim.g.tmux_navigator_save_on_switch = 2
            vim.g.tmux_navigator_disable_when_zoomed = 1
         end,
      },

      { "tami5/sqlite.lua" },

      {
         "luukvbaal/stabilize.nvim",
         config = function()
            require("stabilize").setup()
         end,
      },

      {
         "ruifm/gitlinker.nvim",
         keys = "<leader>gy",
         config = function()
            require("gitlinker").setup()
         end,
      },

      require("plugins.telescope").plugin,

      {
         "https://gitlab.com/yorickpeterse/nvim-pqf",
         config = function()
            require("pqf").setup()
         end,
      },

      {
         "nvim-lua/plenary.nvim",
         module_pattern = { "plenary", "plenary.*" },
      },

      {
         "nvim-lua/popup.nvim",
         module_pattern = { "popup", "popup.*" },
      },

      {
         "nvim-treesitter/nvim-treesitter",
         requires = {
            {
               "nvim-treesitter/playground",
               cmd = { "TSHighlightCapturesUnderCursor", "TSPlaygroundToggle" },
            },
            "nvim-treesitter/nvim-treesitter-textobjects",
            "windwp/nvim-ts-autotag",
            "tree-sitter/tree-sitter-python",
            "tree-sitter/tree-sitter-go",
            "tree-sitter/tree-sitter-typescript",
         },
      },

      {
         "junegunn/vim-easy-align",
         setup = function()
            vim.api.nvim_set_keymap("x", "ga", "<Plug>(EasyAlign)", { noremap = false, silent = true })
         end,
         keys = "<Plug>(EasyAlign)",
      },

      { "kyazdani42/nvim-web-devicons", module = "nvim-web-devicons" },

      {
         "romgrk/barbar.nvim",
         requires = { "kyazdani42/nvim-web-devicons" },
         config = function()
            require "plugins.barbar"
         end,
      },
      {
         "rktjmp/shipwright.nvim",
         cmd = "Shipwright",
         module_pattern = { "shipwright", "shipwright.*" },
      },

      {
         "folke/which-key.nvim",
         keys = {
            { "n", "<leader>" },
            { "n", "g" },
            { "n", "z" },
         },
         config = function()
            require "plugins.which-key"
         end,
      },

      {
         "kyazdani42/nvim-tree.lua",
         cmd = "NvimTreeToggle",
         config = function()
            require "plugins.nvim-tree"
         end,
      },

      {
         "hrsh7th/nvim-cmp",
         config = function()
            require "plugins.cmp"
         end,
         requires = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-vsnip",
            {
               "hrsh7th/vim-vsnip",
               setup = function()
                  vim.cmd [[
              " Jump forward or backward
              imap <expr> <C-n> vsnip#numpable(1)  ? '<Plug>(vsnip-nump-next)' : '<C-n>'
              smap <expr> <C-n> vsnip#numpable(1)  ? '<Plug>(vsnip-nump-next)' : '<C-n>'
              imap <expr> <C-m> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-m>'
              smap <expr> <C-m> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-m>'
            ]]
               end,
            },
         },
      },

      {
         "neovim/nvim-lspconfig",
         config = function()
            require "modules.lsp"
         end,
         requires = {
            "jose-elias-alvarez/null-ls.nvim",
            "jose-elias-alvarez/nvim-lsp-ts-utils",
         },
      },

      {
         "rmehri01/onenord.nvim",
         config = function()
            vim.cmd [[ colorscheme onenord ]]
         end,
      },

      {
         "phaazon/hop.nvim",
         cmd = "HopWord",
         setup = function()
            vim.api.nvim_set_keymap("n", "<Leader>w", "<CMD>HopWord<CR>", { noremap = true })
         end,
         config = function()
            require("hop").setup()
         end,
      },

      {
         "lewis6991/gitsigns.nvim",
         wants = { "plenary.nvim" },
         event = "BufEnter", -- don't need this on scratch buffer
         config = function()
            require "plugins.gitsigns"
         end,
      },

      {
         "andymass/vim-matchup",
         setup = function()
            vim.g.matchup_matchparen_offscreen = {
               method = "popup",
               fullwidth = true,
               highlight = "Normal",
            }
         end,
      },

      {
         "TimUntersberger/neogit",
         requires = {
            "sindrets/diffview.nvim",
         },
         cmd = "Neogit",
         config = function()
            require("neogit").setup {
               disable_signs = false,
               disable_context_highlighting = true,
               signs = {
                  -- { CLOSED, OPENED }
                  section = { "", "" },
                  item = { "+", "-" },
                  hunk = { "", "" },
               },
               integrations = {
                  diffview = true,
               },
            }
         end,
      },

      {
         "vim-test/vim-test",
         cmd = { "TestFile", "TestNearest", "TestSuite", "TestVisit" },
         setup = function()
            require "plugins.vim-test"
         end,
      },

      {
         "norcalli/nvim-colorizer.lua",
         cmd = "ColorizerToggle",
         setup = function()
            vim.api.nvim_set_keymap("n", "<Leader>c", "<CMD>ColorizerToggle<CR>", { noremap = true, silent = true })
         end,
         config = function()
            require("colorizer").setup {
               ["*"] = {
                  css = true,
                  css_fn = true,
                  mode = "background",
               },
            }
         end,
      },

      { "mfussenegger/nvim-jdtls" },

      {
         "simrat39/rust-tools.nvim",
         wants = { "nvim-lspconfig" },
         config = function()
            require("rust-tools").setup {
               tools = {
                  inlay_hints = {
                     show_parameter_hints = true,
                     parameter_hints_prefix = "  <- ",
                     other_hints_prefix = "  => ",
                  },
                  hover_actions = {
                     border = Util.borders,
                  },
               },
               server = {
                  init_options = {
                     detachedFiles = vim.fn.expand "%",
                  },
                  on_attach = Util.lsp_on_attach,
               },
            }
         end,
      },
   },

   config = {
      compile_path = vim.fn.stdpath "data" .. "/site/pack/loader/start/packer.nvim/plugin/packer_compiled.lua",
      git = {
         clone_timeout = 300, -- 5 minutes, I have horrible internet
      },
      display = {
         open_fn = function()
            return require("packer.util").float { border = Util.borders }
         end,
      },
   },
}
