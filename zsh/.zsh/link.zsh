if [ ! -d $HOME/Documents/cs/ ]; then
	for file in /mnt/Centralized/documents/*; do
		ln -s $file $HOME/Documents/
	done;
fi;
unset file;

if [ ! -d $HOME/Pictures/photos/ ]; then
	for picture in /mnt/Centralized/pictures/*; do
		ln -s $picture $HOME/Pictures/
	done;
fi;
unset picture;
