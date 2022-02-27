#!/bin/bash

# FIXME: bash scripts gif2anim, anim2gif
# where to get them? https://legacy.imagemagick.org/Usage/anim_mods/#append

# gif are not the same length...
# down/upsample gifs to be a uniform length
# use average length of specified pokes as the uniform length

# Other option:
# display multiple gifs at the same time
# upstream catimg issue?

echo "Starting Team Display"

# team_entries=(1 4 7 25)
# team_entries=("bulbasaur" "charmander" "squirtle" "pikachu")
team_entries=("squirtle" "giratina")

for _i in "${team_entries[@]}"; do

    # Curl images
    # curl -sL "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/$_i.gif" -o "$_i.gif"
    curl -sL "https://projectpokemon.org/images/normal-sprite/$_i.gif" -o "$_i.gif"

    # Normalize images (have same bottom) by default images are centered
    # Do I need this for gifs (looks like the above sources already have em
    # cropped
    # convert "$_i.gif" -trim "$_i.gif"
    # catimg "$_i.gif"

    # Flip to level the base of each image
    convert -flip "$_i.gif" "$_i.gif"

    # Separate animations into coalesced frames (plus a ".anim" file)
    gif2anim -c "$_i.gif"
done

# Append the separated frames together
for i in $(seq -f '%03g' 1 29); do
    convert "${team_entries[@]/%/_$i.gif}" +append "t_$i.gif"
done

# Rebuild the animation (using one of the ".anim" files)
# Seems like anim2gif is creating these artifacts
anim2gif -c -g -b t "${team_entries[0]}.anim"

# Flip image back
convert -flip t.gif t.gif

# Display
catimg t.gif

# Cleanup
for _i in "${team_entries[@]}"; do
    rm -f "${_i}.anim"
    rm -f "${_i}.gif"
    rm -f ${_i}_???.gif
done
rm -f t.gif
rm -f t_???.gif
