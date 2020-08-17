set encoding=UTF-8
syntax on
if g:is_termguicolors
    set termguicolors
endif
set nowrap showmatch number
set nocompatible autoread hidden
filetype plugin indent on
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
set laststatus=0
set ruler rulerformat=%34(%=%y%m\ ›\ %{getfsize(@%)}B\ ›\ %l:%L:%v%)
se showtabline=2
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
" IDE settings?
au filetype go inoremap <buffer> . .<C-x><C-o>
set omnifunc=go#complete#Complete
set completeopt=longest,menuone,popup,preview
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
