# pokeshell
A shell program to show pokemon sprites in the terminal.

Key features include:
- animated sprites
- multipe pokemon
- automatic resizing
- tab completions

## Dependencies
- [bash](https://www.gnu.org/software/bash/)
- [curl](https://curl.se/)
- [jq](https://stedolan.github.io/jq/)
- [imagemagick](https://imagemagick.org/)
- [timg](https://github.com/hzeller/timg)

## Usage

```bash
pokeshell --help
```

## Examples
TODO

## Similar Projects
pokeshell is not the first player in the pokemon shell art niche and nor will it
be the last. (I just hope that the next project can take these ideas and only
expand on them.) Below is a feature list of the two projects,
[phoneybadger/pokemon-colorscripts](https://gitlab.com/phoneybadger/pokemon-colorscripts) &
[talwat/pokeget](https://github.com/talwat/pokeget), that also fill this role and what
makes `pokeshell` unique among them.

| **Feature**      | **pokeshell** | **pokeget** | **colorscripts** |
|:----------------:|:-------:|:-----------:|:---------------:|
| small            | ✔️       | ✔️           | ✔️               |
| shiny small      | ✔️       | ❌           | ✔️               |
| small forms      | ✔️       | ❌           | ❌               |
| big              | ✔️       | ✔️           | ❌               |
| shiny big        | ✔️       | ❌           | ❌               |
| big forms        | ✔️       | ✔️           | ❌               |
| animated         | ✔️       | ❌           | ❌               |
| genders          | ✔️       | ❌           | ❌               |
| random           | ✔️       | ✔️           | ✔️               |
| random gens      | ❌       | ✔️           | ✔️               |
| tab completion   | ✔️       | ❌           | ❌               |
| resize           | ✔️       | ❌           | ❌               |
| multiple pokemon | ✔️       | ❌           | ❌               |


## Other Pokémon Sprite Terminal Projects
- [rmccorm4/Pokefetch](https://github.com/rmccorm4/pokefetch)
    Fetch Pokedex entries in your terminal
- [HRKings/pokemonsay-newgenerations](https://github.com/HRKings/pokemonsay-newgenerations)
    Cowsay for Pokemon
- [31marcobarbosa/pokeTerm](https://github.com/31marcobarbosa/pokeTerm)
    Display random Pokemon sprite upon opening a terminal

## Sources
A great amount of gratitude goes to the following projects, without which
`pokeshell` would not be possible. Please star/support these sources!

Small sprites: [msikma/pokesprite](https://github.com/msikma/pokesprite)

Big sprites: [PokeAPI](https://pokeapi.co/)
- Specifically: [PokeAPI/pokeapi](https://github.com/PokeAPI/pokeapi) and [PokeAPI/sprites](https://github.com/PokeAPI/sprites)

Animated sprites: [ProjectPokemon](https://projectpokemon.org/home/docs/spriteindex_148)
