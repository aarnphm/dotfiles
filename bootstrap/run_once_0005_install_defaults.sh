#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="${SOURCE_DIR:-"$(pwd)"}"

if [[ "$OSTYPE" == "darwin"* ]]; then
	source "$SOURCE_DIR/bootstrap/0009_osx_defaults.sh"
else
	source "$SOURCE_DIR/bootstrap/0010_arch_defaults.sh"
fi
