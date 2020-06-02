# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

for config in $HOME/.zsh/*.zsh; do
	source $config;
done;
unset config;
# init pyenv
if command -v pyenv &>/dev/null;then
	eval "$(pyenv init -)"
fi;
# check link for zpreztorc
if [ ! -f $HOME/.zpreztorc ]; then
	echo "requires zpreztorc, checking whether installed prezto or not..."
	if [ ! -d $HOME/.zprezto ]; then
		echo "prezto is not installed, should be already tho"
		exit
	fi
	for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
		ln "$rcfile" "$HOME/dotfiles/zsh/.${rcfile:t}"
	done;
fi;
