.PHONY: install

.DEFAULT: install

stow: init
	cd pkg && . ../init/stow.sh
init:
	chmod +x init/*.sh
install: init
	cd init/dmenu-5.0 && sudo make clean install
	./init/install.sh
build:
	docker build -t aar0npham/dotfiles:latest .
run:
	docker run -it aar0npham/dotfiles:latest

