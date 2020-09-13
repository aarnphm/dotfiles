.PHONY: install

.DEFAULT: install

init:
	chmod +x init/*.sh && ./init/init.sh
stow: init
	chmod +x init/stow.sh && cd pkg && . ../init/stow.sh
install: init
	./init/install.sh
build:
	docker build -t aar0npham/dotfiles:latest .
run:
	docker run -it aar0npham/dotfiles:latest

