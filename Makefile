.PHONY: install

init:
	chmod +x init/*.sh && ./init/init.sh
install:
	chmod +x init/*.sh && ./init/install.sh
build:
	docker build -t aar0npham/dotfiles:latest .
run:
	docker run -it aar0npham/dotfiles:latest

