let g:checker = {
            \   'error_sign'   : '⨉',
            \   'warning_sign' : '⬥',
            \   'success_sign' : '',
            \   'error_group'  : 'Error',
            \   'warning_group': 'Function',
            \ }

" define vim-plug here
call plug#begin(g:vim_dir . '/plugged')
" Color scheme
Plug 'rakr/vim-one'
Plug 'sainnhe/gruvbox-material'
Plug 'mkitt/tabline.vim'

" Programmatic
Plug 'dense-analysis/ale'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" syntax
Plug 'sheerun/vim-polyglot'
Plug 'vim-python/python-syntax'

" UI
Plug 'ryanoasis/vim-devicons'
Plug 'preservim/nerdtree'
Plug 'shime/vim-livedown'
Plug 'majutsushi/tagbar'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" Others
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'
call plug#end()

" vim-plug itself
let g:plug_threads = 10
let g:plug_window = 'enew'
highlight! link PlugDeleted Conceal

" set true color terms
colorscheme gruvbox-material
if g:is_termguicolors
    highlight Normal guibg=NONE
    highlight! link LineNr Comment
    highlight! link FoldColumn Comment
endif
if g:has_term
    highlight! link StatusLineTerm StatusLineNC
    highlight! link StatusLineTermNC Terminal
    highlight SpellBad cterm=underline ctermbg=black ctermfg=red
endif
" options to choose: one and gruvbox-material
set background=dark
if get(g:,'colors_name')=='gruvbox-material'
    let g:gruvbox_material_background = 'hard'
endif

" syntax settings
let g:python_highlight_all = 1
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_concealcursor = 'inc'
let g:indentLine_conceallevel = 2

" ale
" Disabled by default
let g:ale_enabled = 0
nmap <silent> <F5> :ALEToggle<CR>
let g:ale_lint_on_enter = 0
" let g:ale_lint_on_text_changed = 'normal'
let g:ale_sign_column_always = 1
let g:ale_set_highlights = 0
let g:ale_sign_error = g:checker.error_sign
let g:ale_sign_warning = g:checker.warning_sign
let g:ale_echo_msg_format = '[%linter%] [%severity%] %s'
let [g:ale_echo_msg_error_str, g:ale_echo_msg_warning_str] = ['E', 'W']
exe 'highlight! link ALEErrorSign ' . g:checker.error_group
exe 'highlight! link ALEWarningSign ' . g:checker.warning_group
" Specific to file types and are here for reference
let g:ale_linters = {
            \   'c'              : ['gcc'],
            \   'css'            : ['csslint'],
            \   'javascript'     : ['standard'],
            \   'json'           : ['jsonlint'],
            \   'markdown'       : ['mdl'],
            \   'python'         : ['flake8'],
            \   'scss'           : ['sasslint'],
            \   'sh'             : ['shellcheck', 'shell'],
            \   'vim'            : ['vint'],
            \   'yaml'           : ['yamllint'],
            \ }
let g:ale_fixers = {
      \    'python': ['black','isort'],
      \}
let g:ale_fix_on_save = 1
let g:ale_vim_vint_show_style_issues = 0

" vim-go
" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go nmap <leader>i  <Plug>(go-info)
autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"
let g:go_def_mode = 'godef'
let g:go_info_mode='gopls'
let g:go_auto_type_info = 1                

" Languageserver-neovim
let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'python': ['/usr/local/bin/pyls'],
    \ 'go': ['$HOME/go/bin/gopls'],
    \ }
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F4> :call LanguageClient#textDocument_rename()<CR>

" NERDTree settings
let NERDTreeShowHidden = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let g:webdevicons_enable_nerdtree = 1
let g:NERDTreeWinPos = "right"
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize=35
map <F3> :NERDTreeToggle<cr>
augroup finalcountdown
  au!
  " autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw" || &buftype == 'quickfix' |q|endif
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) || &buftype == 'quickfix' | q | endif
  "nmap - :Lexplore<cr>
  nmap - :NERDTreeToggle<cr>
augroup END
