set runtimepath+=~/.vim/

" use vim-plug becauseof its minimalistic
"¯\_(ツ)_/¯
if empty(glob('~/.vim/autoload/plug.vim'))
  silent call system('curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
  execute 'source  ~/.vim/autoload/plug.vim'
  augroup plugsetup
    au!
    autocmd VimEnter * PlugInstall
  augroup end
endif

au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-plug
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" define vim-plug here
call plug#begin('~/.vim/plugins')
" fzf with rg
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'joshdick/onedark.vim'
Plug 'rking/ag.vim'
" ale for linting
Plug 'dense-analysis/ale'
" Go support
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" Julia support
" Plug 'JuliaEditorSupport/julia-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" language packs
Plug 'sheerun/vim-polyglot'
" language syntax
Plug 'andrewstuart/vim-kubernetes'
Plug 'vim-python/python-syntax'
Plug 'mrk21/yaml-vim'
Plug 'ekalinin/Dockerfile.vim'
" UI related
Plug 'mkitt/tabline.vim'
Plug 'godlygeek/tabular'
Plug 'preservim/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'Rykka/InstantRst'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-apathy'
Plug 'wakatime/vim-wakatime'
Plug 'Yggdroot/indentLine'
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => init
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:is_unix=has('unix')
let g:is_gui=has('gui_running')
let g:is_termguicolors = has('termguicolors') && !g:is_gui && $COLORTERM isnot# 'xterm-256color'
let g:has_job = has('job')
let g:has_term = has('terminal')

" Setup
if g:is_termguicolors
  set termguicolors
endif
set background=dark
colorscheme onedark
" colorscheme gruvbox-material
" let g:gruvbox_material_background = 'medium'

" Minimal
filetype plugin indent on
syntax enable
set autoindent
set relativenumber
set number
set backspace=indent,eol,start
set complete-=i
set smarttab

set nrformats-=octal

if !has('nvim') && &ttimeoutlen == -1
  set ttimeout
  set ttimeoutlen=100
endif

set incsearch
set noshowcmd
set notitle
set nowrap
set showmatch
set showmode
set hidden
set clipboard=unnamed,unnamedplus
set mouse=a
if has('vim')
    set term=xterm-256color
endif
set wildmode=longest:full,full
set wildcharm=<Tab>
set shortmess+=I
set pastetoggle=<F2>

if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif

if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j " Delete comment character when joining commented lines
endif

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
  set shell=/usr/bin/env\ bash
endif

set autoread

if &history < 1000
  set history=1000
endif
if &tabpagemax < 50
  set tabpagemax=50
endif
if !empty(&viminfo)
  set viminfo^=!
endif
set sessionoptions-=options
set viewoptions-=options

" UI setting
set laststatus=0
set ruler
set rulerformat=%34(%=%y\ ›\ %{getfsize(@%)}B\ ›\ %l:%L%)
" Performance tuning
set lazyredraw
set nocursorline
set hlsearch
set ignorecase
set smartcase

" Misc
set nobackup
set noswapfile
set nowritebackup
set undofile
set undodir=~/.vim/undo
set undolevels=9999
set tabstop=4
command! Ev :e! $MYVIMRC

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mapping
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Mapping
let mapleader=','
nnoremap <leader>, :let @/=''<CR>:noh<CR>
nnoremap <leader># :g/\v^(#\|$)/d_<CR>
nnoremap <leader>b :ls<CR>:buffer<space>
nnoremap <leader>d :w !diff % -<CR>
nnoremap <leader>s :so $MYVIMRC<CR>
nnoremap <silent> <leader>i gg=G``<CR>
nnoremap <leader>l :set list! list?<CR>
nnoremap <silent> <leader>t :%s/\s\+$//e<CR>
nnoremap <leader>w :set wrap! wrap?<CR>
" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>
" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
map <C-up> :tabr<cr>
map <C-down> :tabl<cr>
map <C-left> :tabp<cr>
map <C-right> :tabn<cr>
" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/
" added yank to clipboard shortcut
noremap <M-Y> "*y
noremap <M-P> "*p
noremap <M-y> "+y
noremap <M-p> "+p
" map <M-r> for PlugInstall and <M-d> for PlugClean
map <leader>C :PlugClean<cr>
map <leader>R :PlugInstall<cr>
" use this when lightline is not in use for minimal
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O>:set invpaste paste?<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugin settings
let g:instant_rst_port=5686
" show tabline close button
let g:tablineclosebutton=0
" syntax settings
let g:python_highlight_all = 1
" indent line
" let g:indentLine_concealcursor = 'inc'
let g:indentLine_conceallevel = 1
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
" ale
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
let g:ale_python_pylint_options= '--rcfile $HOME/.pylintrc'
let g:ale_vim_vint_show_style_issues = 0

" fzf
" This is the default extra key bindings
let g:fzf_tags_command = 'ctags -R'
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '40%' }

" You can set up fzf window using a Vim command (Neovim or latest Vim 8 required)
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '10new' }

" Customize fzf colors to match your color scheme
" - fzf#wrap translates this to a set of `--color` options
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Enable per-command history
" - History files will be stored in the specified directory
" - When set, CTRL-N and CTRL-P will be bound to 'next-history' and
"   'previous-history' instead of 'down' and 'up'.
let g:fzf_history_dir = '~/.local/share/fzf-history'
nnoremap <C-f> :Files <CR>

" vim-go
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

" NERDTree settings
let NERDTreeShowHidden = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let g:NERDTreeWinPos = "right"
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize=35
map <F3> :NERDTreeToggle<cr>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) || &buftype == 'quickfix' | q | endif

" I - AM - SPEEEEEEEEED
let g:gitgutter_enabled=1
nnoremap <silent> <M-d> :GitGutterToggle<cr>
let g:gitgutter_realtime = 1
let g:gitgutter_eager = 1
let g:gitgutter_max_signs = 1500
let g:gitgutter_diff_args = '-w'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction 

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
