" define vim-plug here
call plug#begin(g:vim_dir . '/plugged')
" Color scheme
Plug 'rakr/vim-one'
Plug 'sainnhe/gruvbox-material'
Plug 'morhetz/gruvbox'
Plug 'mkitt/tabline.vim'

" Programmatic
Plug 'dense-analysis/ale'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" syntax
Plug 'sheerun/vim-polyglot'
Plug 'vim-python/python-syntax'

" UI
Plug 'ryanoasis/vim-devicons'
Plug 'preservim/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'majutsushi/tagbar'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" Others
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'
Plug 'wakatime/vim-wakatime'
call plug#end()
autocmd BufNew,BufEnter *.json,*.md,*.lua execute "silent! CocEnable"
autocmd BufLeave *.json,*.md,*.lua execute "silent! CocDisable"

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
elseif get(g:,'colors_name')=='gruvbox'
    let g:gruvbox_contrast_dark = 'hard'
endif

" syntax settings
let g:python_highlight_all = 1
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_concealcursor = ''
let g:indentLine_conceallevel = 2

" ale
" Disabled by default
let g:ale_enabled = 1
nmap <silent> <F5> :ALEToggle<CR>
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
" let g:ale_lint_on_text_changed = 'normal'
let g:ale_sign_column_always = 1
let g:ale_set_highlights = 1
" Specific to file types and are here for reference
let g:ale_linters = { 'python' : ['pylint']}
let g:ale_fixers = {'python': ['black','isort']}
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
let g:go_fmt_command = "goimports"
let g:go_info_mode='gopls'
let g:go_auto_type_info = 1
let g:go_fmt_autosave = 1
let g:go_def_mapping_enabled = 0

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

map <F4> <Plug>(coc-rename)
" MarkdownPreview
nmap <C-s> <Plug>MarkdownPreview
nmap <M-s> <Plug>MarkdownPreviewStop
nmap <C-p> <Plug>MarkdownPreviewToggle

" NERDTree settings
let NERDTreeShowHidden = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let g:webdevicons_enable_nerdtree = 1
let g:NERDTreeWinPos = "right"
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize=35
map <F3> :NERDTreeTabsToggle<cr>
augroup finalcountdown
  au!
  " autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw" || &buftype == 'quickfix' |q|endif
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) || &buftype == 'quickfix' | q | endif
  "nmap - :Lexplore<cr>
  nmap - :NERDTreeToggle<cr>
augroup END

" I - AM - SPEEEEEEEEED
let g:gitgutter_enabled=1
nnoremap <silent> <leader>d :GitGutterToggle<cr>
let g:gitgutter_realtime = 1
let g:gitgutter_eager = 1
let g:gitgutter_max_signs = 1500
let g:gitgutter_diff_args = '-w'
