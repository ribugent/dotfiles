#!/bin/bash

[ -d ~/.local/share/omf ] && exit 0

curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
