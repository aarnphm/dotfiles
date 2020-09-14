let g:is_unix=has('unix')
let g:is_gui=has('gui_running')
let g:is_termguicolors = has('termguicolors') && !g:is_gui && $COLORTERM isnot# 'xterm-256color'
let g:has_job = has('job')
let g:has_term = has('terminal')

" get vim and dotfiles directory
let g:vim_dir = expand('$HOME/.vim')
let s:cfg_files = ['minimal', 'plugins', 'bindings', 'plugins_settings']

" use vim-plug becauseof its minimalistic
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

command! Ev :e! $MYVIMRC
" quick access vim files
for s:f in s:cfg_files
    execute 'command! Ev' . s:f[0] . ' :edit! ' . g:vim_dir . '/config/' . s:f . '.vim'
endfor

for s:f in s:cfg_files
    execute 'source ' . g:vim_dir . '/config/' . s:f . '.vim'
endfor

unlet! s:cfg_files s:f

if g:is_termguicolors
  set termguicolors
endif

set background=dark
colorscheme gruvbox-material
let g:gruvbox_material_background = 'medium'

