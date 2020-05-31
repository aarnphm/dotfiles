" use vim settings instead of vi
set nocompatible
filetype off

" Enable filetype plugins
filetype plugin on
filetype indent on

"hide buffers instead of closing
set hidden

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

"maintain undo history
set undofile
set undodir=~/.vim/undo
set noswapfile

"fuzzy find
set path+=**
" lazy file name completion with mouse support
if has('mouse')
	set mouse=a
endif

set wildmenu
set wildignorecase
" ignore files vim doesnt use
set wildignore+=.git,.hg,.svn
set wildignore=*.o,*~,*.pyc,*.obj,*.svn,*.swp,*.class,*.min.*,__pycache__,._*
set wildignore+=*.aux,*.out,*.toc
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest,*.rbc,*.class
set wildignore+=*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp
set wildignore+=*.avi,*.divx,*.mp4,*.webm,*.mov,*.m2ts,*.mkv,*.vob,*.mpg,*.mpeg
set wildignore+=*.mp3,*.oga,*.ogg,*.wav,*.flac
set wildignore+=*.eot,*.otf,*.ttf,*.woff
set wildignore+=*.doc,*.pdf,*.cbr,*.cbz
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.kgb
set wildignore+=*.swp,.lock,.DS_Store,._*


"case insenstivie search
set ignorecase
set smartcase 
set infercase

"backspace behavior
set backspace=indent,eol,start
set whichwrap+=<,>,h,l

" searching
set hlsearch
set incsearch

" disable folding
set nofoldenable

"indent of 4 spaces
set shiftwidth=4

"tabs are tabs ok
set noexpandtab

"identation every four columns
set tabstop=4

"remove trailing whitespaces and ^M chars
augroup ws
  au!
  autocmd FileType c,cpp,java,php,js,json,css,scss,sass,py,rb,coffee,python,twig,xml,yml,ts autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))
augroup end

" set leader key to comma
let mapleader=","

" Show matching brackets when text indicator is over them
set showmatch 
" How many tenths of a second to blink when matching brackets
set mat=2

" autoindent and smartindent
set autoindent
set smartindent
set wrap

" set command height to 2
set cmdheight=2
