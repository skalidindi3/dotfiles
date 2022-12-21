#!/usr/bin/env zsh

if [ ${HOST: -3} = "nuc" ]; then
    # home server
    tmux set -g status-style fg=black,bold,"bg=#8FBCBB"
    tmux set -g window-status-current-style "fg=#8FBCBB",bold,bg=black
    tmux set -g pane-active-border-style "fg=#8FBCBB",bg=black
elif [ ${HOST: -3} = "com" ]; then
    # work host
    tmux set -g status-style fg=black,bold,bg=red
    tmux set -g window-status-current-style fg=red,bold,bg=black
    tmux set -g pane-active-border-style fg=red,bg=black
elif [ ${HOST: -3} = "nal" ]; then
    # work mobile
    tmux set -g status-style fg=black,bold,bg=yellow
    tmux set -g window-status-current-style fg=yellow,bold,bg=black
    tmux set -g pane-active-border-style fg=yellow,bg=black
else
    # use default green
fi
