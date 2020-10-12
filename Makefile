.PHONY: init build run stow

.DEFAULT: init

init:
	chmod +x init/*.sh && ./init/init.sh
stow:
	stow config --target=${HOME}
build:
	docker build -t aar0npham/dotfiles:latest .
run:
	docker run -it aar0npham/dotfiles:latest

