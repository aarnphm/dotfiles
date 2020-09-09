if g:is_termguicolors
    set termguicolors
endif
set title
set noshowmode
set nowrap
set showmatch
set autoread
set number
set nocompatible
set hidden
set clipboard=unnamed,unnamedplus
set mouse=a
if has('vim')
    set term=xterm-256color
endif
set wildmode=longest:full,full
set wildcharm=<Tab>
set shortmess+=I
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O>:set invpaste paste?<CR>
set pastetoggle=<F2>
" UI settings
set rulerformat=%34(%=%y\ ›\ %{getfsize(@%)}B\ ›\ %l:%L:%v%)
set incsearch
se showtabline=2
" Performance tuning
set copyindent
set expandtab
set lazyredraw
set nocursorline
set hlsearch
set ignorecase
set smartcase
set ttyfast
set nobackup
set noswapfile
set nowritebackup
set undofile
set undodir=~/.vim/undo
set undolevels=9999
set shiftwidth=4
set softtabstop=4
set tabstop=4

augroup project
  autocmd!
  autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen
augroup END
