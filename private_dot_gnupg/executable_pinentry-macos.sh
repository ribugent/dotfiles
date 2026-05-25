#!/usr/bin/env bash

_use_curses() {
    # Invoked by Claude CLI — force GUI so it doesn't fight the TUI
    if ! command -v pstree &>/dev/null; then
        echo "pinentry-macos.sh: pstree not found, falling back to pinentry-curses" >&2
        return 0
    fi
    if pstree -p $$ 2>/dev/null | grep -qi 'claude'; then
        return 1
    fi

    # Has a controlling terminal
    if [ -n "$TERM" ] && [ "$TERM" != "dumb" ] && tty -s 2>/dev/null; then
        return 0
    fi

    return 1
}

if _use_curses; then
    exec /opt/homebrew/bin/pinentry-curses "$@"
else
    exec /opt/homebrew/bin/pinentry-mac "$@"
fi
