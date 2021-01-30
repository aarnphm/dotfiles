.PHONY: init build run stow

.DEFAULT_GOAL := help

.DEFAULT: init

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

init:
	chmod +x init/*.sh && ./init/init.sh

stow:
	stow home --target=${HOME} --ignore='stow.sh'

build:
	docker build -t aar0npham/dotfiles:latest .

run:
	docker run -it aar0npham/dotfiles:latest

vmware:
	sudo modprobe -a vmw_vmci vmmon
