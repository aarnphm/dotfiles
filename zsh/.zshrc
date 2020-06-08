# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{exports,aliases,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

for config in $HOME/.zsh/*.zsh; do
	source $config;
done;
unset config;

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/aar0npham/google-cloud-sdk/path.zsh.inc' ]; then . '/home/aar0npham/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/aar0npham/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/aar0npham/google-cloud-sdk/completion.zsh.inc'; fi

