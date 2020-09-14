set notitle
set nowrap
set showmatch
set showmode
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
set pastetoggle=<F2>
" UI setting
set ruler
set conceallevel=1
set concealcursor=ni
set rulerformat=%34(%=%y\ ›\ %{getfsize(@%)}B\ ›\ %l:%L%)
set incsearch
set showtabline=2
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

function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction
