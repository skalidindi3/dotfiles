#!/bin/zsh

mpc_output=$(mpc)
mpc_exit=$?

if (( mpc_exit == 0 )); then
    # NOTE: 57 --> 60 chars max, -2 for utf prefix, -1 for ... suffix
    now_playing=$(echo "$mpc_output" \
        | head -n 1 \
        | awk '{print (length($0) > 57) ? substr($0, 1, 57) "…" : $0}')

    if [[ $mpc_output == *"[playing]"* ]]; then
        formatting="#[fg=#{@nordic_green_bright}]"
        formatting+="⏵︎ "
    elif [[ $mpc_output == *"[paused]"* ]]; then
        formatting="#[fg=#{@nordic_yellow_bright}]"
        formatting+="⏸︎ "
    else
        formatting="#[fg=#{@nordic_red_bright}]"
        formatting+="⏹ "
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
