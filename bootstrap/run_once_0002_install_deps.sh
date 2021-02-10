#!/usr/bin/env bash
set -euo pipefail

trap 'exit' INT

##############################################
# Variables
##############################################

SOURCE_DIR="${SOURCE_DIR:-$(pwd)}"

BUNDLE_FILE="$SOURCE_DIR/Brewfile"
PACMAN_FILE="$SOURCE_DIR/Pacfile.in"
AUR_FILE="$SOURCE_DIR/Aurfile.in"

##############################################
# Functions
##############################################

if [[ `command -v brew` ]];then
    export PKGMN=brew
else
    export PKGOPT=(--needed --noconfirm)
    export PKGI=-Sy
    export PKGR=-Rns
    export PKGMN=pacman
fi

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

function __install() {
    if [[ $1 == "core" ]]; then
        echo_info "Installing pacman packages from ${PACMAN_FILE}..."
        while IFS= read -r package
        do 
            if ! [ -x "$(command -v rainbow)" ]; then
                sudo $PKGMN $PKGI ${PKGOPT[@]} $package
            else
                rainbow --red=error --yellow=warning sudo $PKGMN $PKGI ${PKGOPT[@]} $package
            fi
        done < $PACMAN_FILE
        echo_done "Finished installing packages from ${PACMAN_FILE}"
    elif [[ $1 == "aur" ]]; then
        echo_info "Installing AUR packages from ${AUR_FILE} using yay ..."
        while IFS= read -r package
        do
            yay $PKGI ${PKGOPT[@]} $package
        done <  $AUR_FILE
        echo_done "Finished installing packages from ${AUR_FILE}"
    else
        echo_info "Installing ${1} ..."
        sudo $PKGMN $PKGI $1
    fi
}

##############################################
# Installation here
##############################################

if [[ "$OSTYPE" == "darwin"* ]];then
    echo "Using $BUNDLE_FILE"
    $PKGMN bundle
elif [[ "$OSTYPE" == "linux-gnu"* ]];then
    echo "Using $PACMAN_FILE and $AUR_FILE"
    if ! command -v yay >/dev/null 2>&1; then
        echo "Install yay"
        sudo $PKGMN $PKGI ${PKGOPT[@]} base base-devel wget
        tmpdir="$(command mktemp -d)"
        command cd "${tmpdir}" || return 1
        dl_url="$(curl -sfLS 'https://api.github.com/repos/Jguer/yay/releases/latest' | grep 'browser_download_url' | tail -1 | cut -d '"' -f 4)"
        command wget "${dl_url}"
        command tar xzvf yay_*_x86_64.tar.gz
        command cd yay_*_x86_64 || return 1
        ./yay $PKGI ${PKGOPT[@]} yay-bin
        rm -rf "${tmpdir}"
    fi
    __install core && __install aur
fi
