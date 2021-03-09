local  awful = require("awful")

-- the shell scripts is used to run some daemon
awful.spawn.with_shell("$XDG_CONFIG_HOME/awesome/X/startup.sh")
awesome.register_xproperty("WM_NAME", "string")

-- startup some applications
os.execute("~/.local/bin/xsettingsd-setup")
os.execute("~/.local/bin/ssh-add")
awful.spawn.with_shell("~/.local/bin/auto-lock start")

