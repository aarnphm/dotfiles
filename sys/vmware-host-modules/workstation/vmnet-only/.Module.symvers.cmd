cmd_/home/aarnphm/dotfiles/sys/vmware-host-modules/workstation/vmnet-only/Module.symvers := sed 's/ko$$/o/' /home/aarnphm/dotfiles/sys/vmware-host-modules/workstation/vmnet-only/modules.order | scripts/mod/modpost  -a   -o /home/aarnphm/dotfiles/sys/vmware-host-modules/workstation/vmnet-only/Module.symvers -e -i Module.symvers  -N -T -
