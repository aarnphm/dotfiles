cmd_/home/aarnphm/dotfiles/sys/vmware-host-modules/player/vmmon-only/Module.symvers := sed 's/ko$$/o/' /home/aarnphm/dotfiles/sys/vmware-host-modules/player/vmmon-only/modules.order | scripts/mod/modpost  -a   -o /home/aarnphm/dotfiles/sys/vmware-host-modules/player/vmmon-only/Module.symvers -e -i Module.symvers  -N -T -