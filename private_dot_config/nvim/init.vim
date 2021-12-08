lua require('impatient')

let s:user = "wbthomason"
let s:repo = "packer.nvim"
let s:install_path = stdpath("data") . "/site/pack/packer/opt/" . s:repo
if empty(glob(s:install_path)) > 0
  execute printf("!git clone https://github.com/%s/%s %s", s:user, s:repo, s:install_path)
  packadd repo
endif

let g:mapleader=","

" disable filetype.vim
let g:did_load_filetypes = 1

" order matters
runtime! lua/modules/keymap.lua
runtime! lua/modules/options.lua
runtime! lua/modules/mappings.vim
runtime! lua/modules/util.lua
runtime! lua/modules/statusline.lua

" packer commands
command! PackerInstall packadd packer.nvim | lua require('plugins').install()
command! PackerUpdate  packadd packer.nvim | lua require('plugins').update()
command! PackerSync    packadd packer.nvim | lua require('plugins').sync()
command! PackerClean   packadd packer.nvim | lua require('plugins').clean()
command! PackerStatus  packadd packer.nvim | lua require('plugins').status()
command! PackerCompile packadd packer.nvim | lua require('plugins').compile('~/.config/nvim/plugin/packer_load.vim')
command! -nargs=+ -complete=customlist,v:lua.require'packer'.loader_complete PackerLoad | lua require('packer').loader(<q-args>)
