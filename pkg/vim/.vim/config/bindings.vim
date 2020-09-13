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

au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

