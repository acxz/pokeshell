#!/usr/bin/env sh

mkdir -p /usr/bin
cp -v pokeshell /usr/bin

mkdir -p /usr/share/bash-completion/completions
cp -v pokeshell-completion.bash /usr/share/bash-completion/completions/pokeshell

mkdir -p /usr/share/zsh/site-functions
cp -v pokeshell-completion.bash /usr/share/zsh/site-functions/_pokeshell
