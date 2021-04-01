"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! MyTabLine()
    let s = ''
    for i in range(tabpagenr('$'))
        let tabnr = i + 1 " range() starts at 0
        let winnr = tabpagewinnr(tabnr)
        let buflist = tabpagebuflist(tabnr)
        let bufnr = buflist[winnr - 1]
        let bufname = fnamemodify(bufname(bufnr), ':t')

        let s .= '%' . tabnr . 'T'
        let s .= (tabnr == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
        let s .= ' ' . tabnr

        let n = tabpagewinnr(tabnr,'$')
        if n > 1 | let s .= ':' . n | endif

        let s .= empty(bufname) ? ' [No Name] ' : ' [' . bufname . '] '

        let bufmodified = getbufvar(bufnr, "&mod")
        if bufmodified | let s .= '+ ' | endif
    endfor
    let s .= '%#TabLineFill#'
    return s
endfunction

" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeLine()
    let l:modeline = printf("vim: set ft=%s ts=%d sw=%d tw=%d %set :",
                \ &filetype, &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
    let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
    call append(line("$"), l:modeline)
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

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
" vim: set ft=vim ts=2 sw=2 tw=0 et :
