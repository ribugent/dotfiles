fish_add_path --global --prepend $HOME/.plenv/shims /net/bin/plenv/plenv-net-plugin/bin

function plenv
    functions -e plenv perl
    source (command plenv init - | psub)
    plenv $argv
end

function perl
    functions -e plenv perl
    source (command plenv init - | psub)
    perl $argv
end
