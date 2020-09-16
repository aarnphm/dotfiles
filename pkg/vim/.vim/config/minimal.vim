set notitle
set nowrap
set showmatch
set showmode
set noshowcmd
set number
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
set laststatus=0
set showtabline=2
set confirm " need to save before quiting vim
set ruler
set rulerformat=%34(%=%y\ ›\ %{getfsize(@%)}B\ ›\ %l:%L%)
" Performance tuning
set copyindent
set lazyredraw
set nocursorline
set hlsearch
set ignorecase
set smartcase
set ttyfast

" Misc
set nobackup
set noswapfile
set nowritebackup
set undofile
set undodir=~/.vim/undo
set undolevels=9999
set tabstop=4
