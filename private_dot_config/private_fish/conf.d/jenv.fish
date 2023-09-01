# Fix recurrent issue with shim
rm ~/.jenv/shims/.jenv-shim 2> /dev/null
source (jenv init -|psub)
