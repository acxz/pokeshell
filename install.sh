#!/usr/bin/env bash

install_dir="/usr/local/"

mkdir -pv "${1:-${install_dir}}"
cp -rv bin "${1:-${install_dir}}"
cp -rv share "${1:-${install_dir}}"
