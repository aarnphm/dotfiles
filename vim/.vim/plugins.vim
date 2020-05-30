set runtimepath+=~/.vim/

"¯\_(ツ)_/¯

if empty(glob('~/.vim/autoload/plug.vim'))
  silent call system('mkdir -p ~/.vim/{autoload,bundle,cache,undo,backups,swaps}')
  silent call system('curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
  execute 'source  ~/.vim/autoload/plug.vim'
  augroup plugsetup
    au!
    autocmd VimEnter * PlugInstall
  augroup end
endif

call plug#begin('~/.vim/plugged')
"colors related with syntax hilighting for language (also included language
"pack as well)
Plug 'morhetz/gruvbox'
Plug 'ekalinin/Dockerfile.vim'
Plug 'tpope/vim-git'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'https://github.com/McSinyx/vim-octave.git', {'for': 'octave'}

"programming
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'sheerun/vim-polyglot'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

"language-related settings


"stylish
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'ryanoasis/vim-devicons'
Plug 'chrisbra/colorizer'
Plug 'preservim/nerdtree'

"utilities
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'
Plug 'mileszs/ack.vim'
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'junegunn/limelight.vim', { 'on': 'Goyo' }
Plug 'majutsushi/tagbar', { 'on': 'Tagbar' }
Plug 'junegunn/gv.vim', { 'on': 'GV' }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }

call plug#end()
