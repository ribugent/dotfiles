fish_add_path --global --prepend $HOME/.jenv/shims $HOME/.jenv/bin

function jenv
    functions -e jenv java
    rm ~/.jenv/shims/.jenv-shim 2>/dev/null
    source (command jenv init - | psub)
    jenv $argv
end

function java
    functions -e jenv java
    rm ~/.jenv/shims/.jenv-shim 2>/dev/null
    source (command jenv init - | psub)
    java $argv
end
