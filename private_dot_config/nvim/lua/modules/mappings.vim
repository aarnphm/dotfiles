" Thanks to Steve Losh for this liberating tip
" See http://stevelosh.com/blog/2010/09/coming-home-to-vim

nnoremap ; :
inoremap jj <Esc>

nnoremap / /\v
vnoremap / /\v

" https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
noremap n "Nn"[v:searchforward]
noremap N "nN"[v:searchforward]

" We don't use arrow key in vim
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>

" manual folding
inoremap <F5> <C-O>za
nnoremap <F5> za
onoremap <F5> <C-C>za
vnoremap <F5> zf
" Toggle show/hide invisible chars
nnoremap <leader>I :set list!<cr>
nnoremap \\ :let @/=''<CR>:noh<CR>
nnoremap <silent> <leader>p :%s///g<CR>
nnoremap <silent> <leader>i gg=G<CR>
nnoremap <leader># :g/\v^(#\|$)/d_<CR>
nnoremap <leader>b :ls<CR>:buffer<space>
nnoremap <leader>d :w !diff % -<CR>
nnoremap <leader>S :so $MYVIMRC<CR>
nnoremap <leader>l :set list! list?<CR>
nnoremap <leader>t :%s/\s\+$//e<CR>
" Remove the Windows ^M - when the encodings gets messed up
" for somereason bufread doesn't catch  it first
nnoremap <leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm
nnoremap <leader>w :set wrap! wrap?<CR>
" When you press <leader>r you can search and replace the selected text
nnoremap <leader>ml :call AppendModeLine()<CR>
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>
" this is for transient
" better movement between windows
" nnoremap <C-h> <C-w><C-h>
" nnoremap <C-j> <C-w><C-j>
" nnoremap <C-k> <C-w><C-k>
" nnoremap <C-l> <C-w><C-l>
" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
nnoremap <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/
nnoremap <leader>vs :vsplit <C-r>=expand("%:p:h")<cr>/
nnoremap <leader>s :split <C-r>=expand("%:p:h")<cr>/

" remove Ex mode
map Q <Nop>
" added yank to clipboard shortcut
noremap <M-Y> "*y
noremap <M-P> "*p
noremap <M-y> "+y
noremap <M-p> "+p
" use this when lightline is not in use for minimal
nnoremap <F2> :set invpaste paste?<CR>
imap <F2><C-O>:set invpaste paste?<CR>
" quick resize for split
nnoremap <silent> <leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <leader>- :exe "resize " . (winheight(0) * 2/3)<CR>

" nvimtree
nnoremap <F3> <CMD>NvimTreeToggle<CR>

nnoremap <silent> <C-h> :lua require'nvim-tmux-navigation'.NvimTmuxNavigateLeft()<cr>
nnoremap <silent> <C-j> :lua require'nvim-tmux-navigation'.NvimTmuxNavigateDown()<cr>
nnoremap <silent> <C-k> :lua require'nvim-tmux-navigation'.NvimTmuxNavigateUp()<cr>
nnoremap <silent> <C-l> :lua require'nvim-tmux-navigation'.NvimTmuxNavigateRight()<cr>

