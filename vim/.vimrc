" init to call vim-plug
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
" Programmatic
Plug 'dense-analysis/ale'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
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

" General settings
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
set term=xterm-256color
set wildmenu wildmode=longest:full,full wildcharm=<Tab>
set shortmess+=I
set pastetoggle=<F2>

" UI settings
set listchars=eol:¶,trail:•,tab:▸\
set scrolloff=999
set showbreak=¬\
hi Normal guibg=NONE ctermbg=NONE
set laststatus=0
set ruler rulerformat=%50(%=%<%F%m\ ›\ %{getfsize(@%)}B\ \›\ %l/%L:%v%)

" Performance tuning
set autoindent expandtab lazyredraw nocursorline			 
set hlsearch ignorecase incsearch smartcase ttyfast 
set nobackup noswapfile nowritebackup            
set undofile undodir=~/.vim/undo undolevels=9999 
set shiftwidth=4 softtabstop=4 tabstop=4 	 

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

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

" added yank to clipboard shortcut
noremap <leader>y "+Y
noremap <leader>p "+P

" map <M-r> for PlugInstall and <M-d> for PlugClean
map <M-d> :PlugClean<cr>
map <M-r> :PlugInstall<cr>
"
" Cheeky
cnoreabbrev w!! w !sudo tee > /dev/null %

" Config
let g:go_fmt_command="goimports"
let g:go_auto_type_info=1
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:ale_fix_on_save=1

