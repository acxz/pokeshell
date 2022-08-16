#!/usr/bin/env sh

rm -v /usr/local/bin/pokeshell
rm -v /usr/local/share/bash-completion/completions/pokeshell
rm -v /usr/local/share/zsh/site-functions/_pokeshell

rmdir -v /usr/local/bin
rmdir -v /usr/local/share/bash-completion/completions
rmdir -v /usr/local/share/bash-completion
rmdir -v /usr/local/share/zsh/site-functions
rmdir -v /usr/local/share/zsh
