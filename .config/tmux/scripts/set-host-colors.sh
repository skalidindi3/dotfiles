#!/bin/zsh

OS=$(uname -s)
if [ $OS = "Darwin" ]; then
    LOCALHOSTNAME=$(scutil --get LocalHostName)
elif [ $OS = "Linux" ]; then
    LOCALHOSTNAME=$(hostname)
fi

if [ ${LOCALHOSTNAME: -3} = "-m1" ]; then       # home laptop == "green"
    tmux set -g @host_color \
        "$(tmux show-option -gqv @nordic_green_bright)"
    tmux set -g @host_color_alt \
        "$(tmux show-option -gqv @nordic_red_bright)"
elif [ ${LOCALHOSTNAME: -5} = "-mini" ]; then   # home server == "blue"
    tmux set -g @host_color \
        "$(tmux show-option -gqv @nordic_blue1)"
    tmux set -g @host_color_alt \
        "$(tmux show-option -gqv @nordic_orange_bright)"
elif [ ${LOCALHOSTNAME: -5} = "-lini" ]; then   # home server == "purple"
    tmux set -g @host_color \
        "$(tmux show-option -gqv @nordic_magenta_bright)"
    tmux set -g @host_color_alt \
        "$(tmux show-option -gqv @nordic_yellow_bright)"
else                                            # other == "red"
    tmux set -g @host_color \
        "$(tmux show-option -gqv @nordic_red_dim)"
    tmux set -g @host_color_alt \
        "$(tmux show-option -gqv @nordic_red)"
fi
