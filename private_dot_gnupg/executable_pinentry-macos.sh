#!/usr/bin/env bash

_sentinel="/tmp/.claude-gpg-signing"

_claude_active() {
  [ -f "$_sentinel" ] || return 1
  local age=$(($(date +%s) - $(/usr/bin/stat -f %m "$_sentinel")))
  [ "$age" -lt 120 ]
}

if _claude_active; then
  exec /opt/homebrew/bin/pinentry-mac "$@"
else
  exec /opt/homebrew/bin/pinentry-curses "$@"
fi
