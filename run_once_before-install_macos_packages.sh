#!/usr/bin/env bash
# Packages hash: {{ include "macos/Brewfile" | sha256sum }}

set -euo pipefail

OS="{{ .chezmoi.os }}"

if [[ $OS != "darwin" ]]; then
	exit 0
fi;

brew bundle --file macos/Brewfile --no-lock
