" json pretty print
function! JSONify()
  %!python -mjson.tool
  set syntax=json
endfunction
command! J :call JSONify()
nnoremap <silent> <leader>j <esc>:call JSONify()<cr><esc>


" remove highlighting
nnoremap <silent> <esc><esc> <esc>:nohlsearch<cr><esc>

" remove trailing white space
command! Nows :%s/\s\+$//

" remove blank lines
command! Nobl :g/^\s*$/d

" toggle spellcheck
command! Spell :setlocal spell! spell?
nnoremap <silent> <leader>s :setlocal spell! spell?

" make current buffer executable
command! Chmodx :!chmod a+x %

" fix syntax highlighting
command! FixSyntax :syntax sync fromstart

" pseudo tail functionality
command! Tail :set autoread | au CursorHold * checktime | call feedkeys("G")

" zoom
function! Zoom() abort
  if winnr('$') > 1
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
  else
    execute "silent !tmux resize-pane -Z"
  endif
endfunction
command! Zoom call s:Zoom()
nnoremap <leader>z :call Zoom()<cr>
inoremap <leader>z <ESC>:call Zoom()<cr>a

" let's make some textmode art!
function! AsciiMode()
  e ++enc=cp850
  set nu!
  set virtualedit=all
  set colorcolumn=80
endfunction
command! Ascii :call AsciiMode()

"epic PASTE mode
function! HasPaste()
if &paste
    return 'PASTE MODE '
endif
return ''
endfunction

"for calling cmdline quickly
function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction 

"useful when in visual mode
function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
