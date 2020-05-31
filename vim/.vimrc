let configs = [
            \ "general",
            \ "ui",
            \ "bindings",
            \ "plugins",
            \ "plugins-settings",
            \ "commands",
            \ ]

for file in configs
    let x = expand("~/.vim/".file.".vim")
    if filereadable(x)
        execute 'source' x
    endif
endfor
