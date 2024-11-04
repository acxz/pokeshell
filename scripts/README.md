# scripts

This directory contains helper scripts for the project.

## `create_pokemon_identifiers.py`

Generates pokemon identifiers (such as localized names) using [PokeAPI]() that the sprite backends do not support natively.

## Dependencies

- [python]()
- [python-requests]()

## Usage

```bash
python create_pokemon_identifiers.py
```

## `timing.sh`

Times various Pokemon terminal display projects.

## Dependencies

- [bash]()
- [bc]()
- [hyperfine]()

- [pokeshell]()
- [pokescript]()
- [pokemon-colorscripts]()
- [pokemon-pokeget]()

# TODO: calculate stats (multipliers (maybe using bc?), times)

## Usage

```bash
./timing.sh
```
