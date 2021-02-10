.PHONY: help chez-apply chez-init init run docker-build docker-run build

.DEFAULT_GOAL := run

help: ## Display this help messages
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

full-install: ## install from both .local file
	sudo pacman -Sy --no-confirm --needed ${CURDIR}/Pacfile.local 
	yay -Sy --no-confirm --needed ${CURDIR}/Aurfile.local

chez-update: ## update with all run_once file
	chezmoi update

chez-apply: ## apply chezmoi after changes config file
	chezmoi apply -v --debug --color on

chez-init: ## create chezmoi.toml for configuration
	chezmoi init -S ${CURDIR} -v

docker-build: ## build docker images from Dockerfile
	docker build -t aar0npham/dotfiles:latest .

docker-run: ## test run docker
	docker run -it aar0npham/dotfiles:latest

build: docker-build docker-run ## build and run test code

run: chez-init chez-apply 

init: chez-update chez-apply
