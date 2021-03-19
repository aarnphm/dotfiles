.PHONY: help full-install docker-build docker-run build

.DEFAULT_GOAL := help

LOCALDIR := ${CURDIR}/bootstrap/configs

help: ## Display this help messages
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

full-install: ## install from both .local file
	xargs sudo pacman -Syu --noconfirm --needed < ${LOCALDIR}/Pacfile.local 
	xargs yay -Syu --noconfirm --needed < ${LOCALDIR}/Aurfile.local

docker-build: ## build docker images from Dockerfile
	docker build -t aar0npham/dotfiles:latest .

docker-run: docker-build ## test run docker
	docker run -it aar0npham/dotfiles:latest

build: docker-build docker-run ## build and run test code
