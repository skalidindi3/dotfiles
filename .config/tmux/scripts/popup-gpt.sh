#!/bin/zsh

tmux set status off
nvim \
    +"CodeCompanionChat gemini" \
    +"bwipeout 1" \
    +"normal gs" \
    +"set laststatus=0" \
    +"set cmdheight=0"
