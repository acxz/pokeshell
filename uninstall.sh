#!/usr/bin/env sh

rm -v /usr/bin/pokeshell
rm -v /usr/share/bash-completion/completions/pokeshell
rm -v /usr/share/zsh/site-functions/_pokeshell

rmdir -v /usr/share/bash-completion/completions
rmdir -v /usr/share/bash-completion
rmdir -v /usr/share/zsh/site-functions
rmdir -v /usr/share/zsh
