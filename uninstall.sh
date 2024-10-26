#!/usr/bin/env bash

install_dir="/usr/local/"

rm -v "${1:-${install_dir}}bin/pokeshell"
rm -rv "${1:-${install_dir}}bin/imageshell"
rm -v "${1:-${install_dir}}share/bash-completion/completions/pokeshell"

rmdir -v "${1:-${install_dir}}bin"
rmdir -v "${1:-${install_dir}}share/bash-completion/completions"
rmdir -v "${1:-${install_dir}}share/bash-completion"

rm -rv "${HOME}/.cache/pokeshell" | grep -v "removed '"
