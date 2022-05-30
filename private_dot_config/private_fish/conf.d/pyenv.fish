# set -x fish_user_paths $HOME/.pyenv/shims $fish_user_paths
status is-login; and pyenv init --path | source
status is-interactive; and pyenv init - | source
