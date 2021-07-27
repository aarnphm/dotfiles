local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    execute("!git clone https://github.com/wbthomason/packer.nvim " ..
                install_path)
    execute "packadd packer.nvim"
end

--- Check if a file or directory exists in this path
local function require_plugin(plugin)
    local plugin_prefix = fn.stdpath("data") .. "/site/pack/packer/opt/"

    local plugin_path = plugin_prefix .. plugin .. "/"
    local ok, err, code = os.rename(plugin_path, plugin_path)
    if not ok then
        if code == 13 then
            -- Permission denied, but it exists
            return true
        end
    end
    --	print(ok, err, code)
    if ok then vim.cmd("packadd " .. plugin) end
    return ok, err, code
end

vim.cmd "autocmd BufWritePost plugins.lua PackerCompile" -- Auto compile when there are changes in plugins.lua

return require('packer').startup(function(use)
    -- Packer can manage itself as an optional plugin
    use {'wbthomason/packer.nvim', opt = true}

    -- Lua wrappers for nvim
    use {'norcalli/nvim.lua'}

    -- Android smali file highlights
    use {'mzlogin/vim-smali'}

    -- Status Line
    use {
        'glepnir/galaxyline.nvim',
        branch = 'main',
        requires = {'kyazdani42/nvim-web-devicons'}
    }

    -- Startup Time Plugin
    use 'tweekmonster/startuptime.vim'

    -- Buffer Bar
    use {
        'akinsho/nvim-bufferline.lua',
        requires = {'kyazdani42/nvim-web-devicons'}
    }

    -- Colorscheme
    use 'navarasu/onedark.nvim'

    -- Lua formatter
    use 'andrejlevkovitch/vim-lua-format'

    -- Treesitter
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use "windwp/nvim-ts-autotag"

    -- Dash
    use 'glepnir/dashboard-nvim'

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
    }

    -- Nvim Tree
    use {
        "kyazdani42/nvim-tree.lua",
        requires = {'kyazdani42/nvim-web-devicons'}
    }

    -- Nvim Built in LSP configs
    use "neovim/nvim-lspconfig"
    use "glepnir/lspsaga.nvim"

    -- Auto complete stuff
    use "hrsh7th/nvim-compe"
    use "hrsh7th/vim-vsnip"
    use "rafamadriz/friendly-snippets"

    use {"lewis6991/gitsigns.nvim"}
    use {"liuchengxu/vim-which-key"}
    use {"terrortylor/nvim-comment"}
    use {"kevinhwang91/nvim-bqf"}

    use {
        'norcalli/nvim-colorizer.lua',
        config = function() require'colorizer'.setup() end
    }
end)
