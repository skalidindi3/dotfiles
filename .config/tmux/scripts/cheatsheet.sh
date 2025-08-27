#!/bin/zsh

cat <<EOF
# general tmux
C-b C-r - reload config
C-b s   - session switching (:choose-tree)
C-b q   - pane switching

# popups
C-b i   - ipython
C-b C-t - tunes (ncmpcpp)
C-b C-c - cheatsheet
C-b C-g - ask GPT

# scrollback
C-b /   - fuzzy search scrollback
C-b C-s - save
C-b S   - save with colors

# plugins
C-b I   - install tpm
C-b u   - update tpm plugins

# general terminal
C-t     - fuzzy find cwd
EOF
