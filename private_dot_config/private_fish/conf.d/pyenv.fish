fish_add_path --global --prepend $HOME/.pyenv/shims

function pyenv
    functions -e pyenv python pip
    source (command pyenv init - | psub)
    pyenv $argv
end

function pyhon
    functions -e pyenv python pip
    source (command pyenv init - | psub)
    python $argv
end

function pip
    functions -e pyenv python pip
    source (command pyenv init - | psub)
    pip $argv
end
