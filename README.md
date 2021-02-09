# aaron does dotfiles

<div align="center"><p>automated deployment for <code>!~</code> across Unix-like devices.(<i>currently Arch and MacOS</i>)</p></div>

- managed with [chezmoi](https://www.chezmoi.io/) 
- secrets stored with [BitWarden CLI](https://bitwarden.com/) and [Unix pass](https://www.passwordstore.org/)
- I have included a Docker version of my dotfiles if you want to try it out.

# Installation

```sh 
    $ curl -O "https://raw.githubusercontent.com/aarnphm/dotfiles/main/install.sh" | sh
```
- for first time installer do `make install`
A more responsible options:
- after installing chezmoi you can do `chezmoi init git@github.com:aarnphm/dotfiles.git`
- `chezmoi diff -v` to see different files, `chezmoi apply -v --dry-run` to check for errors
- then run `chezmoi apply -v` to see the magic happens
- Runtime goes zoooom
![runtime vrom vrom](./screenshots/runtime.png)
