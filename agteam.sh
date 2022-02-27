#!/bin/bash

# gif are not the same length...
# down/upsample gifs to be a uniform length
# use average length of specified pokes as the uniform length

# Other option:
# display multiple gifs at the same time
# upstream catimg issue?

# first one has to be the shortest time gif to stop pokemon from disappearing

echo "Starting Team Display"

team_entries=(7 4 1 25)
# team_entries=("bulbasaur" "charmander" "squirtle" "pikachu" "giratina" "zubat" "shaymin")
# team_entries=("squirtle" "charmander" "bulbasaur" "pikachu")

_width=0
_loop_num=0

for _i in "${team_entries[@]}"; do

    # Curl images
    curl -sL "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/$_i.gif" -o "$_i.gif"
    # curl -sL "https://projectpokemon.org/images/normal-sprite/$_i.gif" -o "$_i.gif"

    # Flip to level the base of each image
    convert -flip "$_i.gif" "$_i.gif"

    # Get size
    _prev_width=${_width}
    _prev_sum_width=$((_prev_sum_width + _width))
    _width=$(convert "$_i.gif[0]" -ping -format "%w" info:)
    _height=$(convert "$_i.gif[0]" -ping -format "%h" info:)

    _sum_width=$((_prev_sum_width + _width))
    sum_widths+=("${_sum_width}")
    (( _height > max_height )) && max_height=${_height}

    # Create first combined gif
    if [[ ${_loop_num} == 1 ]]; then
        convert "${team_entries[0]}.gif" -repage "${sum_widths[${_loop_num}]}"x"${max_height}" -coalesce \
                 null: \( "$_i.gif" -coalesce \) \
                 -geometry +"${sum_widths[$((_loop_num - 1))]}"+0 \
                 -layers Composite t.gif
    fi

    # Keep on adding gifs
    if [[ ${_loop_num} -gt 1 ]]; then
        convert t.gif -repage "${sum_widths[${_loop_num}]}"x"${max_height}" -coalesce \
                 null: \( "$_i.gif" -coalesce \) \
                 -geometry +"${sum_widths[$((_loop_num - 1))]}"+0 \
                 -layers Composite t.gif
    fi

    _loop_num=$((_loop_num + 1))

done

# Flip image back
convert -flip t.gif t.gif

# Display
timg t.gif # works with genV 2d and gen8 3d sprites
# catimg t.gif # works with gen8 3d sprites

# Cleanup
for _i in "${team_entries[@]}"; do
    rm -f "${_i}.gif"
done
# rm -f t.gif
