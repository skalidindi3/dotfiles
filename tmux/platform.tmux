#!/usr/bin/env zsh

if [ ${HOST: -3} = "nuc" ]; then    # home server == "blue"
    HOST_TMUX_COLOR="#81a2be"
elif [ ${HOST: -3} = "nal" ]; then  # work mobile == "purple"
    HOST_TMUX_COLOR="#b294bb"
elif [ ${HOST: -3} = "com" ]; then  # work host == "red"
    HOST_TMUX_COLOR="#cc6666"
else                                # other == "green" (non-default)
    HOST_TMUX_COLOR="#b5bd68"
fi
# NOTE: from https://terminal.sexy/
# OTHER #f0c674 == "yellow"
# OTHER #8abeb7 == "cyan"
# NOTE: #8FBCBB == ~nord blue

tmux set -g status-style fg=black,bold,"bg=${HOST_TMUX_COLOR}"
tmux set -g window-status-current-style "fg=${HOST_TMUX_COLOR}",bold,bg=black
tmux set -g pane-active-border-style "fg=${HOST_TMUX_COLOR}",bg=black
