# linking stuff, customize to your own choice
# TODO: instead of static, make dynamic
if [ -d /mnt/Centralized/documents -a -f $HOME/Documents/cs ]; then
	for file in /mnt/Centralized/documents/*; do
		ln -s $file $HOME/Documents/
	done;
fi;
unset file;

if [ -d /mnt/Centralized/pictures -a -f $HOME/Pictures/saved ]; then
	for picture in /mnt/Centralized/pictures/*; do
		ln -s $picture $HOME/Pictures/
	done;
fi;
unset picture;

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
