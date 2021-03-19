FROM archlinux:base-devel

RUN mkdir -p /var/lib/pacman/

RUN pacman -Syu --noconfirm
RUN pacman -S --needed sudo make zsh file curl awk gcc base-devel reflector --noconfirm

RUN reflector --latest 5 --save "/etc/pacman.d/mirrorlist" --sort rate --verbose

RUN useradd -ms /bin/bash arch
RUN gpasswd -a arch wheel
RUN echo 'arch ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER arch

WORKDIR /home/arch/
COPY install .

CMD ["./install"]

