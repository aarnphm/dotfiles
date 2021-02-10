.PHONY: help dpes services framework sys homebrew-install chez-apply chez-init init run docker-build docker-run

.DEFAULT_GOAL := run

help: ## Display this help messages
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

deps: ## setup proper dependencies for each system and chezmoi obviously
	@echo "Install dependencies"
	./bootstrap/run_once_0001_install_chezmoi.sh
	./bootstrap/run_once_0002_install_deps.sh

services: ## setup services and systemd
	@echo "Starting services and systemd"
	./bootstrap/run_once_0003_install_services.sh

framework: ## framework for everything else since chezmoi are unable to store submoddules
	@echo "Installing framework"
	./bootstrap/run_once_0004_install_frameworks.sh

sys: ## configure system defaults
	@echo "Configure system defaults"
	./bootstrap/run_once_0005_install_defaults.sh

homebrew-install: ## install homebrew
	@echo "Installing homebrew"
	./bootstrap/run_once_0008_install_homebrew.sh

chez-apply: ## apply chezmoi after changes config file
	chezmoi apply -v --debug --color on

chez-init: ## create chezmoi.toml for configuration
	chezmoi init -S ${CURDIR} -v

run: deps\
	 chez-init\
	 chez-apply ## run to check deps and apply changes 

init: run\
	services\
	sys\
	homebrew-install\
	framework\
	chez-apply ## defaults to run all options	


docker-build: ## build docker images from Dockerfile
	docker build -t aar0npham/dotfiles:latest .

docker-run: ## test run docker
	docker run -it aar0npham/dotfiles:latest
