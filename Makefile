.PHONY: init build run install

.DEFAULT_GOAL := help

.DEFAULT: build

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install: # first time install
	sudo ./install.sh

build: # build docker file
	docker build -t aar0npham/dotfiles:latest .

run: # run docker images
	docker run -it aar0npham/dotfiles:latest

vmware: # vmware related
	sudo modprobe -a vmw_vmci vmmon
