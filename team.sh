#!/bin/bash

echo "Starting Team Display"

team_entries=(1 25 97 145 143 148)

for _i in "${team_entries[@]}"; do

    # Curl images
    curl -sL "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$_i.png" -o "$_i.png"

    # Normalize images (have same bottom) by default images are centered
    convert "$_i.png" -trim "$_i.png"

    # Flip to level the base of each image
    convert -flip "$_i.png" "$_i.png"
done

# Stitch them with transparent background
convert -background 'rgba(0, 0, 0, 0)' "${team_entries[@]/%/.png}" +append t.png

# Flip image back
convert -flip t.png t.png

catimg t.png

# cleanup
for _i in "${team_entries[@]}"; do
    rm -f "$_i.png"
done
rm -f t.png
