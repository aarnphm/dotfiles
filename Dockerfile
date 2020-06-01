FROM ubuntu:20.04

ARG USER_NAME="testing"
ARG USER_PASSWORD="passw0rd"
ENV USER_NAME $USER_NAME
ENV USER_PASSWORD $USER_PASSWORD

RUN apt-get update && apt-get -y upgrade
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
	export DEBIAN_FRONTEND=noninteractive &&\
	apt-get install -y tzdata && \
	dpkg-reconfigure --frontend noninteractive tzdata
RUN apt-get -y install tmux zsh stow curl wget git npm fonts-powerline locales sudo
RUN locale-gen en_US.UTF-8 
RUN adduser --quiet --disabled-password --shell /bin/zsh --home /home/$USER_NAME --gecos "User" $USER_NAME && \
	echo "${USER_NAME}:${USER_PASSWORD}" | chpasswd && usermod -aG sudo $USER_NAME && \
	echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER $USER_NAME
ENV TERM xterm
ENV TERM xterm
ENV ZSH_THEME powerlevel10k

WORKDIR /home/testing/dotfiles
COPY . .

RUN for dir in "dircolors dotenv zsh vim tmux sh"; do stow $dir; done 
CMD ["zsh"]
