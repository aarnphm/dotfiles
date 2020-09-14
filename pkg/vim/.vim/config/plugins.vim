" define vim-plug here
call plug#begin('~/.vim/plugins')
Plug 'dense-analysis/ale'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
Plug 'vim-python/python-syntax'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mrk21/yaml-vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'mkitt/tabline.vim'
Plug 'preservim/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'Rykka/InstantRst'
Plug 'rking/ag.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sensible'
Plug 'wakatime/vim-wakatime'
Plug 'Yggdroot/indentLine'
Plug 'andrewstuart/vim-kubernetes'
call plug#end()

