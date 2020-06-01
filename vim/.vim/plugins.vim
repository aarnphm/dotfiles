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
"colors related
Plug 'morhetz/gruvbox'
Plug 'sainnhe/gruvbox-material'

"included language pack
Plug 'ekalinin/Dockerfile.vim'
Plug 'tpope/vim-git'
Plug 'ericpruitt/tmux.vim', {'rtp': 'vim/'}
Plug 'cespare/vim-toml'
Plug 'leafgarland/typescript-vim'
Plug 'stephpy/vim-yaml'
Plug 'zinit-zsh/zinit-vim-syntax'
Plug 'plasticboy/vim-markdown'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

"programming
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'sheerun/vim-polyglot'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

"language-related settings


"stylish
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'ryanoasis/vim-devicons'
Plug 'preservim/nerdtree'

"utilities
Plug 'rking/ag.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'junegunn/limelight.vim', { 'on': 'Goyo' }
Plug 'majutsushi/tagbar', { 'on': 'Tagbar' }
Plug 'junegunn/gv.vim', { 'on': 'GV' }

call plug#end()
