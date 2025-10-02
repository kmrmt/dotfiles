#!/bin/bash

make init
make install/mise
mise install

eval "$(~/.local/bin/mise activate bash)"
PATH="$HOME/.local/share/mise/shims:$PATH" zsh -i -c exit