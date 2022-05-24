# pokeshell
A shell program to show pokemon sprites in the terminal.

![pokeshell4](https://user-images.githubusercontent.com/17132214/157562228-6ee73b46-9287-45de-823b-e7c43001b00e.gif)

Key features include:

| ✔️ animated sprites | ✔️ multiple pokemon | ✔️ terminal fit | ✔️ tab completions |
|:-:|:-:|:-:|:-:|

## Dependencies

| - [bash](https://www.gnu.org/software/bash/) | - [curl](https://curl.se/) | - [jq](https://stedolan.github.io/jq/) | - [imagemagick](https://imagemagick.org/) | - [timg](https://github.com/hzeller/timg) |
|:-:|:-:|:-:|:-:|:-:|

## Installation

You can install pokeshell system-wide with the `install.sh` script like so:
```bash
sudo ./install.sh
```

This will allow you to run `pokeshell` anywhere on your system as well as add
bash completions.

An uninstall script is also provided:
```bash
sudo ./uninstall.sh
```

If you do not want to install then you can still run pokeshell anywhere and
use bash completions by adding the following lines to your `~/.bashrc`.

```bash
export PATH=/path/to/pokeshell:$PATH
source /path/to/pokemon-completion.bash
```

## Usage

```bash
pokeshell --help
```

or if running from this directory:
```bash
./pokeshell --help
```

## Examples
![pokeshell1](https://user-images.githubusercontent.com/17132214/157558398-580213fa-3f46-4332-a24e-71bab1c4d033.png)
![pokeshell2](https://user-images.githubusercontent.com/17132214/157558403-8b83eb3d-4e54-44af-b05e-e3cb9a0d1ab3.png)
![pokeshell3](https://user-images.githubusercontent.com/17132214/157558404-ca22357f-7d21-41b4-9cad-282c863205f5.png)

## Sources
A great amount of gratitude goes to the following projects, without which
`pokeshell` would not be possible. Please star/support these sources!

Small sprites: [msikma/pokesprite](https://github.com/msikma/pokesprite)

Big sprites: [PokeAPI](https://pokeapi.co/)
- Specifically: [PokeAPI/pokeapi](https://github.com/PokeAPI/pokeapi) and [PokeAPI/sprites](https://github.com/PokeAPI/sprites)

Animated sprites: [ProjectPokemon](https://projectpokemon.org/home/docs/spriteindex_148)

## Similar Projects
pokeshell is not the first player in the pokemon shell art niche and nor will it
be the last. (I just hope that the next project can take these ideas and only
expand on them.) Below is a feature list of some projects (
[acxz/pokescript](https://github.com/acxz/pokescript),
[talwat/pokeget](https://github.com/talwat/pokeget),
[phoneybadger/pokemon-colorscripts](https://gitlab.com/phoneybadger/pokemon-colorscripts))
that also fill this role and what makes `pokeshell` unique among them.

| **Feature**      | **pokeshell** | **pokescript** | **pokeget** | **colorscripts** |
|:----------------:|:-------------:|:--------------:|:-----------:|:----------------:|
| random           | ✔️            | ✔️               | ✔️           | ✔️                |
| small            | ✔️            | ✔️               | ✔️           | ✔️                |
| small forms      | ✔️            | ✔️               | ❌<sup>1</sup>| ✔️             |
| big              | ✔️            | ❌              | ✔️           | ❌               |
| shiny big        | ✔️            | ❌              | ❌<sup>2</sup>| ❌             |
| big forms        | ✔️            | ❌              | ❌<sup>1</sup>| ❌             |
| animated         | ✔️            | ❌              | ❌          | ❌               |
| terminal fit     | ✔️            | ❌              | ❌          | ❌               |
| genders          | ✔️            | ✔️               | ❌          | ❌               |
| multiple pokemon | ✔️            | ✔️               | ❌          | ❌               |
| tab completion   | ✔️            | ✔️               | ❌          | ❌               |
| caching          | ✔️            | ✔️               | ❌<sup>2</sup>| ✔️              |
| no internet      | ❌           | ✔️               | ❌          | ✔️                |
| block size <sup>#</sup>      | quarter/true image | half | full | half             |
| # dependencies <sup>-</sup>  | 5  | 1             | 2           | 1                |
| default speed <sup>+</sup>   | 1x | 5.8x          | 0.7x        | 1.2x             |
| cached speed <sup>+</sup>    | 1x | 5.8x          | 4.5x        | 1.2x             |
| first run speed <sup>+</sup> | 1x | 16x           | 3x          | 3x               |

<sup>1</sup>: Partial support

<sup>2</sup>: Not by default

<sup>#</sup>: the smaller it is, the higher the resolution

<sup>-</sup>: pokeshell/pokeget use bash, colorscripts uses Python

<sup>+</sup>: Normalized to pokeshell, tested with average of 500 runs, larger
is faster, default speed corresponds to default settings of each script

### Other Similar Projects
- [ph04/pokemon-icat](https://github.com/ph04/pokemon-icat)
    Show Pokemon sprites in Kitty
- [eramdam/pokemonshow](https://github.com/eramdam/pokemonshow)
    Show Pokemon sprites using JavaScript
- [yannjor/krabby](https://github.com/yannjor/krabby)
    Show Pokemon sprites using Rust

## Other Pokémon Sprite Terminal Projects
- [rmccorm4/Pokefetch](https://github.com/rmccorm4/pokefetch)
    Fetch Pokedex entries in your terminal
- [HRKings/pokemonsay-newgenerations](https://github.com/HRKings/pokemonsay-newgenerations)
    Cowsay for Pokemon
- [31marcobarbosa/pokeTerm](https://github.com/31marcobarbosa/pokeTerm)
    Display random Pokemon sprite upon opening a terminal
