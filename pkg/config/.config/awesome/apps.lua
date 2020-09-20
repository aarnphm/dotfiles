local os = os
local apps = {}

apps.default = {
    terminal="alacritty",
    editor ="nvim",
    gui_editor = os.getenv("GUI_EDITOR") or "code",
    browser = os.getenv("BROWSER") or "firefox",
    -- implements kdocker below, since set rules for each windows spawn it should be fine
    spotify = "kdocker -q -o -i /usr/share/icons/ePapirus/32x32/apps/spotify.svg spotify",
    launcher = "rofi -modi drun -i -p -show drun -show-icons",
    lock="xsecurelock",
    screenshot="gyazo",
    filebrowser="pcmanfm",
    audiocontrol="pavucontrol",
}

return apps
