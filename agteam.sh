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
#_type=shiny

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

        frame_diff=$(( _frame - min_frame ))
        _div=$((_frame / min_frame))
        idx_del_str=""

        # Use another interval for extra frames
        extra_frames=$((_frame / _div - min_frame ))
        # Division by zero guard
        if [ "$extra_frames" != 0 ]; then
            extra_frames_div=$((_frame / extra_frames))
        fi

        # Loop through diff frames to see which ones to delete
        prev_extra_frame_num=-1
        added_extra_frame=0
        for (( min_frame_num=0; min_frame_num<=frame_diff; min_frame_num++ )); do
            _frame_num=$(( min_frame_num * _frame / frame_diff ))
            # Division by zero guard
            if [ "$extra_frames" != 0 ]; then
                extra_frame_num=$((_frame_num / extra_frames_div))

                # Reset extra frame counter
                if [ "$extra_frame_num" != "$prev_extra_frame_num" ]; then
                    added_extra_frame=0
                fi
            else
                extra_frame_num="${prev_extra_frame_num}"
            fi

            # Remove frame for current min frame interval
            if [ "$added_extra_frame" == 1 ]; then
                # Check if frame has been added for current extra frame interval
                idx_del_str="$idx_del_str$_frame_num,"
            fi

            # Check if frame has been added for current extra frame interval
            if [ "$extra_frame_num" == "$prev_extra_frame_num" ]; then
                added_extra_frame=1
            fi

            prev_extra_frame_num="${extra_frame_num}"
        done

        # Delete frames
        if [ "$idx_del_str" != "" ]; then
            convert "$_i.gif" -delete "$idx_del_str" "$_i.gif"
        fi

        # Delete extra frames from gif
        new_frame=$(identify "$_i.gif" | wc -l)
        still_extra=$(( new_frame - min_frame ))
        extra_idx_del_str=""
        for (( _extra_num=0; _extra_num<still_extra; _extra_num++ )); do
            idx=$(( _extra_num * new_frame / still_extra))
            extra_idx_del_str="$extra_idx_del_str$idx,"
        done

        # Delete extra frames
        if [ "$extra_idx_del_str" != "" ]; then
            convert "$_i.gif" -delete "$extra_idx_del_str" "$_i.gif"
        fi

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
