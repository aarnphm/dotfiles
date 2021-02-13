### file descriptions

- [run_once_0001_install_pkgman.sh](./run_once_0001_install_pkgman.sh.tmpl) will install either `brew` or `yay` depending on OS defined by `.chezmoi.os`
- [run_once_0002_install_chezmoi.sh](./run_once_0002_install_chezmoi.sh.tmpl) will install chezmoi for first time initialization
- [run_once_0003_install_deps.sh](./run_once_0003_install_deps.sh.tmpl) will install my dependencies for day to day uses
- [run_once_0004_install_services.sh](./run_once_0004_install_services.sh.tmpl) will initialise some services using either Mac's services or `systemd`
- [run_once_0005_install_frameworks.sh](./run_once_0005_install_frameworks.sh.tmpl) will install some packages like pyenv, gcloud, etc
- [run_once_0009_sys_default.sh](./run_once_0009_sys_defaults.sh.tmpl) will setup some hacker defaults

_customize it to your heart's content_
