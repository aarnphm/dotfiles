""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set runtimepath+=~/.vim/
"¯\_(ツ)_/¯
if empty(glob('~/.vim/autoload/plug.vim'))
  silent call system('curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
  execute 'source  ~/.vim/autoload/plug.vim'
  augroup plugsetup
    au!
    autocmd VimEnter * PlugInstall
  augroup end
endif
" define vim-plug here
call plug#begin('~/.vim/plugged')
" Color scheme
Plug 'rakr/vim-one'
Plug 'mkitt/tabline.vim'

" Programmatic
Plug 'dense-analysis/ale'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" UI
Plug 'ryanoasis/vim-devicons'
Plug 'preservim/nerdtree'
Plug 'shime/vim-livedown'
Plug 'majutsushi/tagbar'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
" Others
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General settings
if has('termguicolors')
  set termguicolors
endif
set encoding=UTF-8
syntax on
colorscheme one                           
set nowrap showmatch number
set nocompatible autoread hidden
filetype plugin indent on
set background=dark
set backspace=indent,eol,start
set clipboard=unnamed,unnamedplus
set encoding=utf8
set mouse=a
if has('vim')
    set term=xterm-256color
endif
set wildmenu wildmode=longest:full,full wildcharm=<Tab>
set shortmess+=I
set pastetoggle=<F2>

" UI settings
set listchars=eol:¶,trail:•,tab:▸\
set showbreak=¬\
hi Normal guibg=NONE ctermbg=NONE
set showtabline=2
hi TabLine      ctermfg=NONE  ctermbg=NONE     cterm=NONE
hi TabLineFill  ctermfg=NONE  ctermbg=NONE     cterm=NONE
hi TabLineSel   ctermfg=NONE  ctermbg=NONE     cterm=NONE
let g:tablineclosebutton=1
set laststatus=0
set ruler 
set rulerformat=%34(%=%y%m\ ›\ %{getfsize(@%)}B\ ›\ %l:%L:%v%)

" Performance tuning
set autoindent expandtab lazyredraw nocursorline			 
set hlsearch ignorecase incsearch smartcase ttyfast 
set nobackup noswapfile nowritebackup            
set undofile undodir=~/.vim/undo undolevels=9999 
set shiftwidth=4 softtabstop=4 tabstop=4

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mapping
let mapleader=','				
nnoremap <leader>, :let @/=''<CR>:noh<CR>	
nnoremap <leader># :g/\v^(#\|$)/d_<CR>         
nnoremap <leader>b :ls<CR>:buffer<space>       
nnoremap <leader>d :w !diff % -<CR>            
nnoremap <silent> <leader>i gg=G``<CR>         
nnoremap <leader>l :set list! list?<CR>        
nnoremap <leader>s :source $MYVIMRC<CR>
nnoremap <silent> <leader>t :%s/\s\+$//e<CR>    
nnoremap <leader>w :set wrap! wrap?<CR>         

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
noremap <M-y> "*y
noremap <M-p> "*p
noremap <M-Y> "+y
noremap <M-P> "+p

" map <M-r> for PlugInstall and <M-d> for PlugClean
map <leader>c :PlugClean<cr>
map <leader>r :PlugInstall<cr>

" Cheeky
cnoreabbrev w!! w !sudo tee > /dev/null %

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" IDE settings?
au filetype go inoremap <buffer> . .<C-x><C-o>
set omnifunc=go#complete#Complete
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-n>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-p>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Config
" vim-go settings
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
  "autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw" || &buftype == 'quickfix' |q|endif
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) || &buftype == 'quickfix' | q | endif
  "nmap - :Lexplore<cr>
  nmap - :NERDTreeToggle<cr>
augroup END

" Languageserver-neovim
let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'python': ['/usr/local/bin/pyls'],
    \ 'go': ['$HOME/go/bin/gopls'],
    \ }
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F4> :call LanguageClient#textDocument_rename()<CR>

