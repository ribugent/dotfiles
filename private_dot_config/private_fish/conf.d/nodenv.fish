fish_add_path --global --prepend $HOME/.nodenv/shims $HOME/.nodenv/bin

function nodenv
    functions -e nodenv
    source (command nodenv init - | psub)
    nodenv $argv
end
