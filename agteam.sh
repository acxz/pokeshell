#!/usr/bin/env bash

echo "Starting Team Display"

#team_entries=(7 4 1 25)
#team_entries=("bulbasaur" "charmander" "squirtle" "pikachu" "giratina" "zubat" "shaymin")
team_entries=("bulbasaur" "charmander" "squirtle" "charizard-megax")
#team_entries=("munchlax" "jigglypuff" "rayquaza" "gyarados")
team_entries=("zapdos" "articuno" "moltres" "lugia" "charizard-megay" "yveltal")
#team_entries=("lugia" "squirtle")
#team_entries=("giratina" "squirtle")
#team_entries=("giratina" "squirtle")
#team_entries=("squirtle" "pikachu")

_type=normal
#_type=shiny

_width=0
min_frame=100

for _i in "${team_entries[@]}"; do
    # Curl gifs
    #curl -sL "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/$_i.gif" -o "${_i}.gif"
    curl -sL "https://projectpokemon.org/images/$_type-sprite/$_i.gif" -o "${_i}.gif"

    # Flip to level the base of each gif
    convert -flip "${_i}.gif" "$_i.gif"

    # Get size
    _width=$(convert "$_i.gif[0]" -ping -format "%w" info:)
    _height=$(convert "$_i.gif[0]" -ping -format "%h" info:)

    _sum_width=$((_sum_width + _width))
    sum_widths+=("${_sum_width}")
    (( _height > max_height )) && max_height=${_height}

    _frame=$(identify "$_i.gif" | wc -l)
    frames+=("${_frame}")
    (( _frame < min_frame )) && min_frame=${_frame}
done

specified_frame=$min_frame
coalesce_str="convert ${team_entries[0]}.gif"

for _loop_num in "${!team_entries[@]}"; do
    _frame=${frames[$_loop_num]}

    if [ "$_frame" -gt "$specified_frame" ]; then
        # Delete extra frames from gif
        extra_frames=$(( _frame - specified_frame ))
        extra_idx_del_str=""

        for (( _extra_num=0; _extra_num<extra_frames; _extra_num++ )); do
            idx=$(( _extra_num * _frame / extra_frames ))
            extra_idx_del_str="$extra_idx_del_str$idx,"
        done

        convert "${team_entries[_loop_num]}.gif" -delete "$extra_idx_del_str" "${team_entries[_loop_num]}.gif"
    else
        # Insert extra frames into gif
        extra_frames=$(( specified_frame - _frame ))

        for (( _extra_num=0; _extra_num<extra_frames; _extra_num++ )); do
            idx=$(( _extra_num * _frame / extra_frames + _extra_num ))
            convert "${team_entries[_loop_num]}.gif" "${team_entries[_loop_num]}.gif[$idx]" -insert $idx "${team_entries[_loop_num]}.gif"
        done
    fi

    if [[ ${_loop_num} -gt 0 ]]; then
        coalesce_str="${coalesce_str} \
            -repage ${sum_widths[-1]}x${max_height} -coalesce \
            null: \( ${team_entries[_loop_num]}.gif -coalesce \) \
            -geometry +${sum_widths[$((_loop_num - 1))]}+0 \
            -layers Composite\
        "
    fi
done

coalesce_str="${coalesce_str} t.gif"
eval "$coalesce_str"

# Flip image back
convert -flip t.gif t.gif

# Cleanup
for _i in "${team_entries[@]}"; do
    rm -f "${_i}.gif"
done

# Display
#timg t.gif
catimg t.gif

rm -f t.gif
