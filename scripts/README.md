# scripts

This directory contains helper scripts for the project.

## `create_pokemon_identifiers.py`

Generates pokemon identifiers (such as localized names) using [PokeAPI]() that the sprite backends do not support natively.

## Dependencies

- [uv](https://docs.astral.sh/uv/)

## Usage

```bash
uv run create_pokemon_identifiers.py
```

## `timing.sh`

Times various Pokemon terminal display projects.

## Dependencies

- [bash](https://www.gnu.org/software/bash/)
- [hyperfine](https://github.com/sharkdp/hyperfine/tree/master)
- [uv](https://docs.astral.sh/uv/)

- [pokemon-colorscripts](https://gitlab.com/phoneybadger/pokemon-colorscripts)
- [pokeget-rs](https://github.com/talwat/pokeget-rs)
- [pokescript](https://github.com/acxz/pokescript)
- [pokeshell](https://github.com/acxz/pokeshell)

## Usage

Run:

```bash
./timing.sh
```

Then open `timing.png`.
