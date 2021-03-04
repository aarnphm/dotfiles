function! ZathuraOpenPdf()
    let curFile = substitute(bufname("%"), ".tex", ".pdf", "")
    execute "silent !zathura " curFile "&"
endfunction

nnoremap <A-o> :call ZathuraOpenPdf()<CR>
