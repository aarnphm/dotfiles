# aarn's dotfiles
_yet another dotfile repo_

just a tiny collection of my development environment

- I have included a Docker version of my dotfiles if you want to try it out.
- Make sure you have `docker` installed. then do `make build` the followed by `make run`

# Folder structures
- `stow` is used for symlink manager
- `init`: contains scripts to run for first time setup. do `make install`
    - inside `init/init.sh` contains some of `curl` commands to setup [alacritty](https://github.com/alacritty/alacritty).
- `pkg` contains all necessary folders. enjoy !

