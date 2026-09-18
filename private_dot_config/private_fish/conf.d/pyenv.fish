fish_add_path --global --prepend $HOME/.pyenv/shims

function pyenv
    functions -e pyenv
    source (command pyenv init - | psub)
    pyenv $argv
end
