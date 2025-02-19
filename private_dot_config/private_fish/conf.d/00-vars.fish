if test (uname) = "Linux"
    set -x BROWSER xdg-open
    set -x GTK_OVERLAY_SCROLLING 0

    if test "$XDG_SESSION_TYPE" = "wayland"
        set -x MOZ_ENABLE_WAYLAND 1
    end
end

if test (uname) = "Darwin"
    set -l HOMEBREW_PREFIX
    if test (uname -m) = "arm64"
        set HOMEBREW_PREFIX /opt/homebrew
    else
        set HOMEBREW_PREFIX /usr/local
    end

    fish_add_path $HOMEBREW_PREFIX/opt/curl/bin
    fish_add_path $HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin
    fish_add_path $HOMEBREW_PREFIX/opt/findutils/libexec/gnubin
end

set -x EDITOR nvim
set -x MANPAGER 'less -R --use-color -Dd+r -Du+b'
set -x SAM_CLI_TELEMETRY 0
# set -x GTK_USE_PORTAL 1
set -x VIRTUAL_ENV_DISABLE_PROMPT 1
set -x grc_plugin_ignore_execs df
set -x theme_nerd_fonts yes
