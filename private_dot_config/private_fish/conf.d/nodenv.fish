fish_add_path --global --prepend $HOME/.nodenv/shims $HOME/.nodenv/bin

function nodenv
    functions -e nodenv node npm npx
    source (command nodenv init - | psub)
    nodenv $argv
end

function node
    functions -e nodenv node npm npx
    source (command nodenv init - | psub)
    node $argv
end

function npm
    functions -e nodenv node npm npx
    source (command nodenv init - | psub)
    npm $argv
end

function npx
    functions -e nodenv node npm npx
    source (command nodenv init - | psub)
    npx $argv
end
