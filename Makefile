.PHONY: install fmt

install:
	@./install.sh

fmt:
	@shfmt -l -w -ci -i 2 .
