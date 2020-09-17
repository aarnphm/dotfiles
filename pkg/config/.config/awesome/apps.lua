local os = os
local apps = {}

apps.default = {
    terminal="alacritty",
    editor ="nvim",
    gui_editor = os.getenv("GUI_EDITOR") or "code-insiders",
    browser = os.getenv("BROWSER") or "firefox",
    spotify = "kdocker -q -o -i /usr/share/icons/ePapirus/64x64/apps/spotify.svg spotify",
    launcher = "rofi -modi drun -i -p -show drun -show-icons",
    lock="xsecurelock",
    screenshot="gyazo",
    filebrowser="pcmanfm",
    audiocontrol="pavucontrol",
}

return apps
