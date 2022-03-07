#!/usr/bin/env sh

mkdir -p /usr/local/bin
cp -v pokeshell /usr/local/bin

mkdir -p /usr/local/share/bash-completion/completions
cp -v pokeshell-completion.bash /usr/local/share/bash-completion/completions/pokeshell

mkdir -p /usr/local/share/zsh/site-functions
cp -v pokeshell-completion.bash /usr/local/share/zsh/site-functions/_pokeshell
