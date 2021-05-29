.PHONY: help full-install

.DEFAULT_GOAL := full-install

LOCALDIR := ${HOME}/.local/share/chezmoi/bootstrap/configs

help: ## Display this help messages
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

full-install: ## install from both .local file
	xargs sudo pacman -Syu --noconfirm --needed < ${LOCALDIR}/Pacfile.local 
	xargs yay -Syu --noconfirm --needed < ${LOCALDIR}/Aurfile.local
