# chezmoi does dotfiles

<div align="center">_automated deployment for <code>!~</code> across Unix-like devices_</div>

- managed with [chezmoi](https://www.chezmoi.io/) 
- secrets stored with [BitWarden CLI](https://bitwarden.com/) and [Unix pass](https://www.passwordstore.org/)
- I have included a Docker version of my dotfiles if you want to try it out.

# Installation

```sh 
    $ curl -sfL https://git.io/chezmoi | sh
    $ sh -c "https://raw.githubusercontent.com/aarnphm/dotfiles/main/install.sh"
```
A more responsible options:
- after installing chezmoi you can do `chezmoi init git@github.com:aarnphm/dotfiles.git`
- `chezmoi diff -v` to see different files, `chezmoi apply -v --dry-run` to check for errors
- then run `chezmoi apply -v` to see the magic happens


