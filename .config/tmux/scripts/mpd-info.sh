#!/bin/zsh

# inspired by janoamaral/tokyo-night-tmux

mpc_output=$(mpc)
mpc_exit=$?

if (( mpc_exit == 0 )); then
    # NOTE: 56 --> 60 chars max, -3 for icon prefix, -1 for ... suffix
    now_playing=$(echo "$mpc_output" \
        | head -n 1 \
        | awk '{print (length($0) > 56) ? substr($0, 1, 56) "…" : $0 " "}')

    percentage=$(echo "$mpc_output" | head -2 | grep -o '[0-9]\+%' | sed 's/%//')
    elapsed_in_num_chars=$(echo "${#now_playing} * $percentage / 100" | bc)
    now_playing="${now_playing[0,elapsed_in_num_chars]}#[noreverse,nobold]${now_playing[elapsed_in_num_chars+1,-1]}"

    if [[ $mpc_output == *"[playing]"* ]]; then
        formatting="#[fg=#{@nordic_green_bright},reverse,bold]"
        formatting+=" ⏵︎ "
    elif [[ $mpc_output == *"[paused]"* ]]; then
        formatting="#[fg=#{@nordic_yellow_bright},reverse,bold]"
        formatting+=" ⏸︎ "
    else
        formatting="#[fg=#{@nordic_red_bright}]"
        formatting+=" ⏹ "
        volume="$(echo "$now_playing" | awk '{ print $1, $2 }')"
        now_playing="no audio // ${volume}"
    fi
else
    formatting="#[fg=#{@nordic_gray4}]"
    formatting+="⏹ "
    now_playing="no audio // mpd unavailable"
fi

echo "$formatting$now_playing"

# reset the status-interval value after ncmpcpp
# reduced it down to 1 to force an update
tmux set -g status-interval \
    "$(tmux show-option -gqv @statusbar_interval_reset_value)"
