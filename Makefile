.PHONY: init build run

.DEFAULT_GOAL := help

.DEFAULT: build

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build:
	docker build -t aar0npham/dotfiles:latest .

run:
	docker run -it aar0npham/dotfiles:latest

vmware:
	sudo modprobe -a vmw_vmci vmmon
