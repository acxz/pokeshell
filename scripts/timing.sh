#!/usr/bin/env bash

#hyperfine --shell=none --warmup=5 --runs 1000 'pokeget --hide-name bulbasaur' 'pokescript bulbasaur' 'pokemon-colorscripts --no-title --name bulbasaur' 'pokeshell -s bulbasaur' --export-json timing.json
hyperfine --shell=none --warmup=5 --runs 1000 'pokeget --hide-name bulbasaur' 'pokemon-colorscripts --no-title --name bulbasaur' 'pokeshell -s bulbasaur' --export-json timing.json

# TODO we may want to have our own whisker plot with plotly
wget https://raw.githubusercontent.com/sharkdp/hyperfine/refs/heads/master/scripts/plot_whisker.py -O plot_whisker.py

uv run plot_whisker.py timing.json -o timing.png

rm timing.json
rm plot_whisker.py
