O = {
    auto_close_tree = 0,
    auto_complete = true,
    hidden_files = true,
    wrap_lines = false,
    number = true,
    relative_number = true,
    shell = 'bash',

    treesitter = {
        ensure_installed = "all",
        ignore_install = {"haskell"},
        highlight = {enabled = true},
        playground = {enabled = true},
        rainbow = {enabled = false}
    },

    python = {
        linter = 'pylint,mypy,flake8',
        formatter = 'black',
        autoformat = true,
        isort = true,
        diagnostics = {virtual_text = true, signs = true, underline = true}
    },
    lua = {
        formatter = 'lua-format',
        autoformat = false,
        diagnostics = {virtual_text = true, signs = true, underline = true}
    },
    sh = {
        linter = 'shellcheck',
        formatter = 'shfmt',
        autoformat = false,
        diagnostics = {virtual_text = true, signs = true, underline = true}
    },
    tsserver = {
        linter = 'eslint',
        formatter = 'prettier',
        autoformat = false,
        diagnostics = {virtual_text = true, signs = true, underline = true}
    },
    json = {
        formatter = 'prettier',
        autoformat = false,
        diagnostics = {virtual_text = true, signs = true, underline = true}
    },
    tailwindls = {
        filetypes = {
            'html', 'css', 'scss', 'javascript', 'javascriptreact',
            'typescript', 'typescriptreact'
        }
    },
    clang = {
        diagnostics = {virtual_text = true, signs = true, underline = true}
    }
}

DATA_PATH = vim.fn.stdpath('data')
CACHE_PATH = vim.fn.stdpath('cache')
