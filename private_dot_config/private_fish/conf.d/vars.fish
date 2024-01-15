if test (uname -m) = "Linux"
    set -x BROWSER xdg-open
end
set -x EDITOR vim
set -x MANPAGER 'less -R --use-color -Dd+r -Du+b'
set -x GTK_OVERLAY_SCROLLING 0
# set -x GTK_USE_PORTAL 1
set -x VIRTUAL_ENV_DISABLE_PROMPT 1
set -x grc_plugin_ignore_execs df
set -x theme_nerd_fonts yes

if test "$XDG_SESSION_TYPE" = "wayland"
    set -x MOZ_ENABLE_WAYLAND 1
end
