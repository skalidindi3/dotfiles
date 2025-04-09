#!/usr/bin/env zsh

OS=$(uname -s)
if [ $OS = "Darwin" ]; then
    LOCALHOSTNAME=$(scutil --get LocalHostName)
elif [ $OS = "Linux" ]; then
    LOCALHOSTNAME=$(hostname)
fi

if [ ${LOCALHOSTNAME: -3} = "-m1" ]; then       # home laptop == "blue"
    HOST_TMUX_COLOR="#81a2be"
elif [ ${LOCALHOSTNAME: -5} = "-mini" ]; then   # home server == "cyan"
    HOST_TMUX_COLOR="#5e8d87"
elif [ ${LOCALHOSTNAME: -5} = "-lini" ]; then   # home server == "purple"
    HOST_TMUX_COLOR="#b294bb"
elif [ ${LOCALHOSTNAME: -3} = "-m2" ]; then     # work laptop == "red"
    HOST_TMUX_COLOR="#cc6666"
else                                # other == "green" (non-default)
    HOST_TMUX_COLOR="#b5bd68"
fi
# NOTE: from https://terminal.sexy/
# OTHER #f0c674 == "yellow"
# NOTE: #8fbcbb == ~nord blue

tmux set -g status-style fg=black,bold,"bg=${HOST_TMUX_COLOR}"
tmux set -g window-status-current-style "fg=${HOST_TMUX_COLOR}",bold,bg=black
tmux set -g pane-active-border-style "fg=${HOST_TMUX_COLOR}",bg=black
