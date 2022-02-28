#!/bin/bash

echo "Starting Team Display"

#team_entries=(7 4 1 25)
#team_entries=("bulbasaur" "charmander" "squirtle" "pikachu" "giratina" "zubat" "shaymin")
team_entries=("bulbasaur" "charmander" "squirtle" "charizard-megax")
#team_entries=("munchlax" "jigglypuff" "rayquaza" "gyarados")
#team_entries=("zapdos" "articuno" "moltres" "lugia" "zubat" "yveltal")
#team_entries=("lugia" "squirtle")
#team_entries=("giratina" "squirtle")
#team_entries=("squirtle" "pikachu")

_type=normal
_type=shiny

_width=0
min_frame=100

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
done

_loop_num=0
for _i in "${team_entries[@]}"; do
    _frame=${frames[$_loop_num]}

    # No need to sync with the smallest frame gif
    if [ "${_frame}" != "${min_frame}" ]; then

        # Ceiling division
        _div=$(((_frame + min_frame) / min_frame))
        idx_del_str=""

        # Use another interval for missing frames
        missing_frames=$((min_frame - (_frame + _div) / _div))
        # Division by zero guard
        if [ "$missing_frames" != 0 ]; then
            missing_frames_div=$(((_frame + missing_frames) / missing_frames))
        fi

        # Loop through frames to see which ones to delete
        prev_min_frame_num=-1
        prev_missing_frame_num=-1
        added_missing_frame=0
        for (( _frame_num=0; _frame_num<=_frame; _frame_num++ )); do
            min_frame_num=$((_frame_num / _div))
            # Division by zero guard
            if [ "$missing_frames" != 0 ]; then
                missing_frame_num=$((_frame_num / missing_frames_div))

                # Reset missing frame counter
                if [ "$missing_frame_num" != "$prev_missing_frame_num" ]; then
                    added_missing_frame=0
                fi
            else
                missing_frame_num="${prev_missing_frame_num}"
            fi

            # Check if frame has been added for current min frame interval
            if [ "$min_frame_num" == "$prev_min_frame_num" ] && \
                [ "$added_missing_frame" == 1 ]; then
                # Check if frame has been added for current missing frame interval
                idx_del_str="$idx_del_str$_frame_num,"
            fi

            # Check if frame has been added for current missing frame interval
            if [ "$missing_frame_num" == "$prev_missing_frame_num" ]; then
                added_missing_frame=1
            fi

            prev_min_frame_num="${min_frame_num}"
            prev_missing_frame_num="${missing_frame_num}"
        done

        # Delete extra frames
        convert "$_i.gif" -delete "$idx_del_str" "$_i.gif"

        # Pad gif with duplicates for missing frames
        new_frame=$(identify "$_i.gif" | wc -l)
        still_missing=$((min_frame - $(identify "$_i.gif" | wc -l)))
        for (( _missing_num=0; _missing_num<still_missing; _missing_num++ )); do
            idx=$(( _missing_num * (new_frame) / (still_missing)))
            convert "$_i.gif" "$_i.gif[$idx]" -insert $idx "$_i.gif"
        done

        fi
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
