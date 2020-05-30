" show matching brackets
set showmatch

"disable startup message
set shortmess+=I

"syntax higlighting
syntax on
set synmaxcol=512
filetype plugin on

"show line numbers
set number

"no line wrap
set nowrap

"hilight cursor
set cursorline

" show invisibles
set list
set listchars=
set listchars+=tab:·\ 
set listchars+=trail:·
set listchars+=extends:»
set listchars+=precedes:«
set listchars+=nbsp:░

" split style
set fillchars=vert:▒

" setup paste mode 
set pastetoggle=<F2>

" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

