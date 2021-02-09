.PHONY: help init build run install

.DEFAULT_GOAL := help

.DEFAULT: run

help: ## Display this help messages
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

homebrew-install:
	@echo "Installing homebrew"
	./bootstrap/0008_install_homebrew.sh

deps:
	@echo "Install dependencies"
	./bootstrap/0001_install_chezmoi.sh
	./bootstrap/0002_install_deps.sh

run: deps chez-init chez-apply

