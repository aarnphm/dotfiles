FROM archlinux:base-devel
MAINTAINER Aaron Pham <aaronpham0103@gmail.com>

RUN mkdir -p /var/lib/pacman/

RUN pacman -Syu --noconfirm
RUN pacman -S sudo git make zsh chezmoi file awk gcc base-devel reflector --noconfirm

RUN reflector --latest 5 --save "/etc/pacman.d/mirrorlist" --sort rate --verbose

RUN useradd -ms /bin/bash arch
RUN gpasswd -a arch wheel
RUN echo 'arch ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER arch

RUN mkdir /home/arch/dotfiles
COPY  --chown=arch:users . ./home/arch/dotfiles
WORKDIR /home/arch/dotfiles

CMD ["make"]
