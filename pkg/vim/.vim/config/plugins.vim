" define vim-plug here
call plug#begin('~/.vim/plugins')
" fzf with rg
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'rking/ag.vim'
" ale for linting
Plug 'dense-analysis/ale'
" go support
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" vscode like support
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" language packs
Plug 'sheerun/vim-polyglot'
" language syntax
Plug 'tbastos/vim-lua'
Plug 'andrewstuart/vim-kubernetes'
Plug 'vim-python/python-syntax'
Plug 'mrk21/yaml-vim'
Plug 'ekalinin/Dockerfile.vim'
" UI related
Plug 'mkitt/tabline.vim'
Plug 'preservim/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'Rykka/InstantRst'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-apathy'
Plug 'wakatime/vim-wakatime'
Plug 'Yggdroot/indentLine'
call plug#end()

