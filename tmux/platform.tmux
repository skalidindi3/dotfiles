HOSTNAME=$(hostname)
if [ ${HOSTNAME: -3} = "nuc" ]; then
    # home server
    tmux set -g status-style fg=white,bold,bg=blue
    tmux set -g window-status-current-style fg=blue,bold,bg=white
    tmux set -g pane-active-border-style fg=blue,bg=black
elif [ ${HOSTNAME: -3} = "com" ]; then
    # work host
    tmux set -g status-style fg=white,bold,bg=red
    tmux set -g window-status-current-style fg=red,bold,bg=white
    tmux set -g pane-active-border-style fg=red,bg=black
elif [ ${HOSTNAME: -3} = "nal" ]; then
    # work host
    tmux set -g status-style fg=black,bold,bg=yellow
    tmux set -g window-status-current-style fg=yellow,bold,bg=black
    tmux set -g pane-active-border-style fg=yellow,bg=black
else
    echo other >> /tmp/out.moo.txt
    tmux set -g status-style fg=white,bold,bg=purple
    tmux set -g window-status-current-style fg=purple,bold,bg=white
    tmux set -g pane-active-border-style fg=purple,bg=black
fi
