.PHONY: help init build run install

.DEFAULT_GOAL := help

.DEFAULT: run

help: ## Display this help messages
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

deps: ## setup proper dependencies for each system and chezmoi obviously
	@echo "Install dependencies"
	./bootstrap/0001_install_chezmoi.sh
	./bootstrap/0002_install_deps.sh

services: ## setup services and systemd
	@echo "Starting services and systemd"
	./bootstrap/0003_install_services.sh

framework: ## framework for everything else since chezmoi are unable to store submoddules
	@echo "Installing framework"
	./bootstrap/0004_install_frameworks.sh
homebrew-install:
	@echo "Installing homebrew"
	./bootstrap/0008_install_homebrew.sh


run: deps chez-init chez-apply

