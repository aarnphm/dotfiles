cmd_/home/aarnphm/dotfiles/sys/vmware-host-modules/workstation/vmnet-only/modules.order := {   echo /home/aarnphm/dotfiles/sys/vmware-host-modules/workstation/vmnet-only/vmnet.ko; :; } | awk '!x[$$0]++' - > /home/aarnphm/dotfiles/sys/vmware-host-modules/workstation/vmnet-only/modules.order