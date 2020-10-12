#!/bin/bash

set -e

. init/distro.sh
. init/packages.sh
. init/helpers.sh

echo_info "Installing from core ..."
_install core

echo_info "Installing from AUR ..."
_install aur
