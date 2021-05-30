<h1 align="center">dots.</h1>

<div align="center"><p>automated deployment for <code>!~</code> across Unix-based system.</p></div>

<h2 align="center">fyi.</h2>

- managed with [chezmoi](https://www.chezmoi.io/)
- secrets stored with [BitWarden CLI](https://bitwarden.com/) and [Unix pass](https://www.passwordstore.org/)
- I have included a Docker version of my dotfiles if you want to try it out.
- check [desktop](./bootstrap/screenshots/desktop.png) as current setup

<h2 align="center">installation.</h2>

```sh 
    $ sh -c "$(curl -fsLS git.io/chezmoi)" -- init --apply aarnphm 
```

<h2 align="center">scripts.</h2>

- [run_once_0001_install_pkgman.sh](./run_once_0001_install_pkgman.sh.tmpl) will install either `brew` or `yay` depending on OS defined by `.chezmoi.os`
- [run_once_0002_install_deps.sh](./run_once_0002_install_deps.sh.tmpl) will install my dependencies for day to day uses
- [run_once_0003_install_services.sh](./run_once_0003_install_services.sh.tmpl) will initialise some services using either Mac's services or `systemd`
- [run_once_0004_install_frameworks.sh](./run_once_0004_install_frameworks.sh.tmpl) will install some packages like pyenv, gcloud, etc
- [run_once_0009_sys_default.sh](./run_once_0009_sys_defaults.sh.tmpl) will setup some hacker defaults

<h2 align="center">todo.</h3>

- [x] Customs tasks messages (check [autopush_dotfiles](./dot_local/exact_bin/executable_autopush-dotfiles.tmpl))
- [ ] Tidy up awesome
- [ ] Release schedule
- [ ] Cron jobs for different branches
- [ ] Rotate bitwarden password every two weeks, secure with gpg
- [ ] save some local docs with pass
- [ ] (when i have time): custom arch ISO

<!-- vim: set ft=markdown ts=4 sw=4 tw=0 et : -->
