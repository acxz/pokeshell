#!/bin/bash

# FIXME: catimg autoscales on width not height (how to autoscale on the smaller one)

echo "Starting Team Display"

team_entries=(1 4 7 25 39 37)
# case for autoscaling based on width and can't see full height
#team_entries=(487)

for _i in "${team_entries[@]}"; do

    # Curl images
    curl -sL "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$_i.png" -o "$_i.png"

    # Normalize images (have same bottom) by default images are centered
    convert "$_i.png" -trim "$_i.png"

    # Upscale images for higher resolution
    convert "$_i.png" -magnify -magnify -magnify "$_i.png"

    # Distort handles removing white pixel border on newer gens>5
    convert "$_i.png" +distort SRT '1,0' "$_i.png"

    # Sharpen higher res image to reduce blur
    convert "$_i.png" -unsharp 0x6+0.5+0 "$_i.png"

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
