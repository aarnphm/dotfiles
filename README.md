# YADF
_yet another dotfile repo_


# instruction

- clone the repo with `git clone --recursive https://github.com/aar0npham/yadf.git $HOME/dotfiles`
- run `sh/init.sh` for the magic to happen
- to update all submodule do `git config --global submodule.recurse true`

powerfull command : 
```bash
for x in $(find . -type d) ; do if [ -d "${x}/.git" ] ; then cd "${x}" ; origin="$(git config --get remote.origin.url)" ; cd - 1>/dev/null; git submodule add "${origin}" "${x}" ; fi ; done
```

# todo.
* [x] added config for setup macOS
* [x] finish more binding for vim
