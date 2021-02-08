#!/bin/bash

set -eufo pipefail
trap "exit" INT

##############################################
# Packages options from both pacman and AUR
##############################################

export PKG=(
xorg xorg-server xorg-xinit nftables sshguard
nvidia nvidia-dkms nvidia-settings nvidia-prime
android-tools android-udev fzf mesa stow tmux arandr dialog awesome 
feh nitrogen tree base-devel asciinema kitty xdg-user-dirs firefox 
nm-connection-editor pcmanfm pulseaudio pulseaudio-bluetooth pulseaudio-alsa 
alsa-utils gcc cmake ripgrep ctags lxappearance redshift vlc xsettingsd xsecurelock 
imagemagick acpi ibus ibus-unikey gnome-keyring libgnome-keyring bluez blueman nnn bluez-utils 
pavucontrol scrot docker zathura curl  vim cronie neovim caprine termite lightdm gparted 
mate-polkit qt5-base htop kvantum-qt5 wireless-tools network-manager-applet openssh openvpn sshfs net-tools)

export AUR=(
awmtt rofi bitwarden lightdm-mini-greeter nm-applet ncdu bleachbit cacheclean kdocker
adobe-source-han-serif-otc-fonts adobe-source-han-sans-otc-fonts noto-fonts-emoji
discord dmenu-git github-cli slack-desktop dnsutils visual-studio-code-bin
autofs fet.sh-git polkit inkscape samba ccls wine jre-openjdk jdk-openjdk 
zoom postgresql pgadmin4 spicetify-cli materia-gtk-theme papirus-icon-theme qt5ct pyenv 
vmware-workstation nodejs npm rainbow ruby-colorls spotify picom-git redshift-qt unclutter 
optimus-manager-qt bbswitch numix-circle-icon-theme-git teams gyazo lib32-libappindicator-gtk2 
lib32-libappindicator-gtk3
)

##############################################
# Distro options
##############################################

export PKGMN=pacman
export PKGOPT=(--needed --noconfirm)
export PKGU=-Syu
export PKGI=-Sy
export PKGR=-Rns

##############################################
# Functions
##############################################

function echo_error() {
  printf '\n\033[31mERROR:\033[0m %s\n' "$1"
}

function echo_warning() {
  printf '\n\033[33mWARNING:\033[0m %s\n' "$1"
}

function echo_done() {
  printf '\n\033[32mDONE:\033[0m %s\n' "$1"
}

function echo_info() {
  printf '\n\033[36m%s\033[0m\n' "$1"
}

function _update() {
  if [[ $1 == "system" ]]; then
    echo_info "Updating system packages..."
    sudo "$PKGMN" "$PKGU" "${PKGOPT[@]}"
  else
    echo_info "Ugrading ${1}..."
    sudo "$PKGMN" "$PKGU" "$1"
  fi
}

function _install() {
  if [[ $1 == "core" ]]; then
    for pkg in "${PKG[@]}"; do
      echo_info "Installing ${pkg}..."
      if ! [ -x "$(command -v rainbow)" ]; then
        sudo "$PKGMN" "$PKGI" "${PKGOPT[@]}" "$pkg" 
      else
        rainbow --red=error --yellow=warning sudo "$PKGMN" "$PKGI" "${PKGOPT[@]}" "$pkg" 
      fi
      echo_done "${pkg} installed!"
    done
   elif [[ $1 == "aur" ]]; then
    for aur in "${AUR[@]}"; do
     echo_info "Installing ${aur} ..."
     yay -Sy "$aur" --needed --noconfirm
     echo_done "${aur} installed!"
    done
   else
    echo_info "Installing ${1} ..."
    sudo "$PKGMN" "$PKGI" "$1"
  fi
}

##############################################
# Install and setup first time
##############################################

echo_info "Installing from core ..."
_install core

if ! builtin type -p 'yay' >/dev/null 2>&1; then
    echo 'Install yay.'
    sudo pacman -S --needed base base-devel wget
    tmpdir="$(command mktemp -d)"
    command cd "${tmpdir}" || return 1
    dl_url="$(
        command curl -sfLS 'https://api.github.com/repos/Jguer/yay/releases/latest' |
        command grep 'browser_download_url' |
        command cut -d '"' -f 4
    )"
    command wget "${dl_url}"
    command tar xzvf yay_*_x86_64.tar.gz
    command cd yay_*_x86_64 || return 1
    ./yay -Sy yay-bin
    rm -rf "${tmpdir}"
fi

echo_info "Installing from AUR ..."
_install aur

##############################################
# log cron
crontab `chezmoi source-path`/config/cronfile

# bitwarden 
npm install -g @bitwarden/cli

if [[ ! -f $HOME/.vim/autoload/plug.vim ]]; then
    echo_info "Installing vim-plug..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim;
fi

# zinit
if [[ ! -d $HOME/.zinit ]]; then
    echo_info "Installing zinit..."
    curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh;
fi;

# nnn plugins install
echo_info "Install nnn plugins..."
curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh;
git clone https://github.com/sebastiencs/icons-in-terminal.git && cd icons-in-terminal && ./install.sh

# gcp
if [[ ! -d $HOME/google-cloud-sdk ]]; then
    echo_info "Install gcloud..."
    curl https://sdk.cloud.google.com | bash && exec -l $SHELL;
fi;
