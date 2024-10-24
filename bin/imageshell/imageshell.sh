#!/usr/bin/env bash

# functions to display and stitch animated and static images

# example usage:
# https://github.com/acxz/pokeshell
# https://github.com/acxz/waifushell
# https://github.com/acxz/wallshell

# bash tips
# functions in bash
# https://stackoverflow.com/a/23585994
# ${1:?} makes argument to function mandatory
# input array names cannot be the same as the array name in function
# https://stackoverflow.com/a/33777659

function imgshl_stitch_images () {
    local -n _images
    local scale
    local cache_dir

    _images=${1:?}
    scale=${2:?}
    cache_dir=${3:?}

    if [ ${#_images[@]} != 1 ]; then
        if [ $scale == 1 ]; then
            # Get scale height to resize all images to
            max_height=2160
            for _i in "${_images[@]}"; do
                # Get size
                width_height=$(identify "${_i}" | cut -f3 -d " ")
                height=$(echo "$width_height" | cut -f2 -d "x")
                (( height > max_height )) && max_height=${height}
            done

            # Only scale up to terminal height
            terminal_height=2160
            scale_height=$max_height
            (( max_height > terminal_height )) && scale_height=$terminal_height

            # Trim, scale, and stitch them
            magick "${_images[@]}" -trim -scale x"${scale_height}" +append "$cache_dir/t.tiff"
        else
            # Trim and stitch them
            # PNG: hack for pokeshell, because chafa doesn't like pokeshell tiff images
            # at small image sizes png vs tiff doesn't cause any noticeable slowdown anyway
            magick -background 'rgba(0, 0, 0, 0' "${_images[@]}" -trim -gravity South +append PNG:"$cache_dir/t.tiff"
        fi
        display_file="$cache_dir/t.tiff"
    else
        # Trim image
        magick "${_images[0]}" -trim "${_images[0]}"
        display_file="${_images[0]}"
    fi
}

function imgshl_display_images () {
    local display_file
    local pixel_perfect

    display_file=${1:?}
    pixel_perfect=${2:?}

    if [ $pixel_perfect == 1 ]; then
        # pre scale for pixel perfect chafa
        chafa -w 1 --symbols all --scale 8 "${display_file}"
    else
        chafa --symbols all "$display_file"
    fi
}

function imgshl_cleanup_images () {
    local -n _images
    local cache
    local cache_dir

    _images=${1:?}
    cache=${2:?}
    cache_dir=${3:?}

    if [ "$cache" == 0 ]; then
        for _i in "${_images[@]}"; do
            rm -f "${_i}"
        done
    fi
    rm -f "$cache_dir/t.tiff"
}

function imgshl_stitch_ani_images () {
    local -n _images
    local scale
    local cache
    local cache_dir

    _images=${1:?}
    scale=${2:?}
    cache=${3:?}
    cache_dir=${4:?}

    if [ ${#_images[@]} != 1 ]; then
        if [ $scale == 1 ]; then
            # Get scale height to resize all images to
            max_height=2160
            for _i in "${_images[@]}"; do
                # Get size
                width_height=$(identify "${_i}" | grep "\[0\]" | cut -f3 -d " ")
                height=$(echo "$width_height" | cut -f2 -d "x")
                (( height > max_height )) && max_height=${height}
            done

            # Only scale up to terminal height
            terminal_height=2160
            scale_height=$max_height
            (( max_height > terminal_height )) && scale_height=$terminal_height

            for _i in "${_images[@]}"; do
                # Scale
                magick "${_i}" -scale x"${scale_height}" "${_i}s"
            done
        else
            for _i in "${_images[@]}"; do
                # Create tmp file to modify
                cp "${_i}" "${_i}s"
            done
        fi

        width=0
        min_frame=100
        sum_widths=("0")

        for _i in "${_images[@]}"; do
            # Get size
            width_height=$(identify "${_i}s" | grep "\[0\]" | cut -f3 -d " ")
            width=$(echo "$width_height" | cut -f1 -d "x")
            height=$(echo "$width_height" | cut -f2 -d "x")

            sum_width=$((sum_width + width))
            sum_widths+=("${sum_width}")

            heights+=("${height}")
            (( height > max_height )) && max_height=${height}

            frame=$(identify "${_i}s" | wc -l)
            frames+=("${frame}")
            (( frame < min_frame )) && min_frame=${frame}
        done

        specified_frame=$min_frame

        # Correct gravity for first image
        magick "${_images[0]/%/s}" \
            -repage "${sum_widths[1]}x${max_height}+0+$((max_height - heights[0]))" \
            "${_images[0]/%/s}"

        coalesce_str="magick ${_images[0]/%/s}"

        for _loop_num in "${!_images[@]}"; do
            frame=${frames[_loop_num]}

            if [ "$frame" -gt "$specified_frame" ]; then
                # Delete extra frames from gif
                extra_frames=$(( frame - specified_frame ))
                extra_idx_del_str=""

                for (( _extra_num=0; _extra_num<extra_frames; _extra_num++ )); do
                    idx=$(( _extra_num * frame / extra_frames ))
                    extra_idx_del_str="$extra_idx_del_str$idx,"
                done

                magick "${_images[_loop_num]/%/s}" -delete "$extra_idx_del_str" "${_images[_loop_num]/%/s}"
            else
                # Insert extra frames into gif
                extra_frames=$(( specified_frame - frame ))

                for (( _extra_num=0; _extra_num<extra_frames; _extra_num++ )); do
                    idx=$(( _extra_num * frame / extra_frames + _extra_num ))
                    magick "${_images[_loop_num]/%/s}" "${_images[_loop_num]/%/s}[$idx]" -insert $idx "${_images[_loop_num]/%/s}"
                done
            fi

            if [[ ${_loop_num} -gt 0 ]]; then
                coalesce_str="${coalesce_str} \
                    -repage ${sum_widths[${#sum_widths[@]}-1]}x${max_height} -coalesce \
                    null: \( ${_images[_loop_num]/%/s} -coalesce \) \
                    -geometry +${sum_widths[_loop_num]}+$((max_height - heights[_loop_num])) \
                    -layers Composite \
                "
            fi
        done

        display_file="$cache_dir/t.gif"

        coalesce_str="${coalesce_str} $display_file"
        eval "$coalesce_str"

        # Cleanup
        for _i in "${_images[@]}"; do
            if [ "$cache" == 0 ]; then
                rm -f "${_i}"
            fi
            rm -f "${_i}s"
        done

        trap ctrl_c INT
        function  ctrl_c() {
            rm -f "$display_file"
        }
    else
        display_file="${_images[0]}"
    fi
}

function imgshl_display_ani_images () {
    local display_file
    display_file="${1:?}"
    chafa --format symbols --symbols all "$display_file"
}

function imgshl_display () {
    local -n __images
    local use_ani
    local scale
    local pixel_perfect
    local cache
    local cache_dir

    __images=${1:?}
    use_ani=${2:?}
    scale=${3:?}
    pixel_perfect=${4:?}
    cache=${5:?}
    cache_dir=${6:?}

    # Stitch images and display
    if [ $use_ani == 0 ]; then
        imgshl_stitch_images __images $scale $cache_dir
        imgshl_display_images "$display_file" $pixel_perfect
        imgshl_cleanup_images __images $cache $cache_dir
    else
        imgshl_stitch_ani_images __images $scale $cache $cache_dir
        imgshl_display_ani_images "$display_file"
    fi
}
