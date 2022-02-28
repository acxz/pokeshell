#!/bin/bash

echo "Starting Team Display"

#team_entries=(7 4 1 25)
#team_entries=("bulbasaur" "charmander" "squirtle" "pikachu" "giratina" "zubat" "shaymin")
team_entries=("bulbasaur" "charmander" "squirtle" "charizard-megax")
#team_entries=("munchlax" "jigglypuff" "rayquaza" "gyarados")
team_entries=("zapdos" "articuno" "moltres" "lugia" "zubat" "yveltal")
#team_entries=("lugia" "squirtle")
#team_entries=("giratina" "squirtle")
#team_entries=("giratina" "squirtle")
#team_entries=("squirtle" "pikachu")

_type=normal
#_type=shiny

_width=0
min_frame=100
frame_sum=0

for _i in "${team_entries[@]}"; do
    # Curl images
    #curl -sL "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/$_i.gif" -o "${_i}.gif"
    curl -sL "https://projectpokemon.org/images/$_type-sprite/$_i.gif" -o "${_i}.gif"

    # Flip to level the base of each image
    convert -flip "${_i}.gif" "$_i.gif"

    # Get size
    _prev_width=${_width}
    _prev_sum_width=$((_prev_sum_width + _width))
    _width=$(convert "$_i.gif[0]" -ping -format "%w" info:)
    _height=$(convert "$_i.gif[0]" -ping -format "%h" info:)

    _sum_width=$((_prev_sum_width + _width))
    sum_widths+=("${_sum_width}")
    (( _height > max_height )) && max_height=${_height}

    _frame=$(identify "$_i.gif" | wc -l)
    frames+=("${_frame}")
    (( _frame < min_frame )) && min_frame=${_frame}
    frame_sum=$(( frame_sum + _frame ))
done

# logic to pick avg/min/in between
#avg_frame=$(( (frame_sum + ${#team_entries[@]} / 2) / ${#team_entries[@]} ))
#factor=10
#specified_frame=$(( min_frame + (avg_frame - min_frame) / factor ))
specified_frame=$min_frame

_loop_num=0
for _i in "${team_entries[@]}"; do
    _frame=${frames[$_loop_num]}

    if [ "$_frame" -gt "$specified_frame" ]; then
        # Delete extra frames from gif
        extra_frames=$(( _frame - specified_frame ))
        extra_idx_del_str=""

        for (( _extra_num=0; _extra_num<extra_frames; _extra_num++ )); do
            idx=$(( _extra_num * _frame / extra_frames ))
            extra_idx_del_str="$extra_idx_del_str$idx,"
        done

        convert "$_i.gif" -delete "$extra_idx_del_str" "$_i.gif"
    else
        # Insert extra frames into gif
        extra_frames=$(( specified_frame - _frame ))

        for (( _extra_num=0; _extra_num<extra_frames; _extra_num++ )); do
            idx=$(( _extra_num * _frame / extra_frames + _extra_num ))
            convert "$_i.gif" "$_i.gif[$idx]" -insert $idx "$_i.gif"
        done

    fi

    identify "$_i.gif" | wc -l

    _loop_num=$((_loop_num + 1))
done

_loop_num=0
for _i in "${team_entries[@]}"; do
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

# Cleanup
for _i in "${team_entries[@]}"; do
    rm -f "${_i}.gif"
done

# Display
timg t.gif

rm -f t.gif
