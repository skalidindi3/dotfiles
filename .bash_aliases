##########
# Colors #
##########
# Color Codes
RED=$(printf "\x1b[1;31m")
GREEN=$(printf "\x1b[1;32m")
BLUE=$(printf "\x1b[1;34m")
YELLOW=$(printf "\x1b[0;33m")
RESET=$(printf "\x1b[0m")
# `ls` Colors
export LSCOLORS='ExDxxxxxCxxxgxxxxxExEx'
export LS_COLORS='di=1;34:ln=1;33:so=0:pi=0:ex=1;32:bd=0:cd=36:su=0:sg=0:tw=1;34:ow=1;34'
# `man` Colors
export LESS_TERMCAP_us=$'\033[04;38;5;215m'
export LESS_TERMCAP_ue=$'\033[0m'
export LESS_TERMCAP_md=$'\033[01;38;5;74m'
export LESS_TERMCAP_me=$'\033[0m'
# Check current 8/16 color support
show_colors() {
    echo -e "\033[0;30mBLACK\t\033[1;37mWHITE"
    echo -e "\033[0;34mBLUE\t\033[1;34mLIGHT_BLUE"
    echo -e "\033[0;32mGREEN\t\033[1;32mLIGHT_GREEN"
    echo -e "\033[0;36mCYAN\t\033[1;36mLIGHT_CYAN"
    echo -e "\033[0;31mRED\t\033[1;31mLIGHT_RED"
    echo -e "\033[0;35mPURPLE\t\033[1;35mLIGHT_PURPLE"
    echo -e "\033[0;33mYELLOW\t\033[1;33mLIGHT_YELLOW"
    echo -e "\033[1;30mGRAY\t\033[0;37mLIGHT_GRAY"
    echo -e "\033[0mRESET"

    for x in {0..5}; do
        echo --- 
        for z in 0 10 60 70; do
            for y in {30..37}; do
                y=$((y + z))
                printf '\e[%d;%dm%-12s\e[0m' "$x" "$y" "$(printf ' \\e[%d;%dm] ' "$x" "$y")" && printf ' '
            done
            printf '\n'
        done
    done

    # colors256
    local c i j

    printf "Standard 16 colors\n"
    for ((c = 0; c < 17; c++)); do
        printf "|%s%3d%s" "$(tput setaf "$c")" "$c" "$(tput sgr0)"
    done
    printf "|\n\n"

    printf "Colors 16 to 231 for 256 colors\n"
    for ((c = 16, i = j = 0; c < 232; c++, i++)); do
        printf "|"
        ((i > 5 && (i = 0, ++j))) && printf " |"
        ((j > 5 && (j = 0, 1)))   && printf "\b \n|"
        printf "%s%3d%s" "$(tput setaf "$c")" "$c" "$(tput sgr0)"
    done
    printf "|\n\n"

    printf "Greyscale 232 to 255 for 256 colors\n"
    for ((; c < 256; c++)); do
        printf "|%s%3d%s" "$(tput setaf "$c")" "$c" "$(tput sgr0)"
    done
    printf "|\n"
}
# Remove colors
alias strip_colors="perl -pe 's/\e\[?.*?[\@-~]//g'"


###########
# Folders #
###########
if which zoxide &> /dev/null; then
    if [ -n "$ZSH_VERSION" ]; then
        eval "$(zoxide init --cmd cd zsh)"
    fi
fi
if [ -e ~/Documents/projects ]; then
    cdp() { cd "${HOME}/Documents/projects/$@"; }
    if [ -n "$ZSH_VERSION" ]; then
        compctl -W "${HOME}/Documents/projects/$1" -/ cdp
    fi
fi


############
# Homebrew #
############
if [ -e /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi


##########
# Python #
##########
if [ -e $HOME/.local/bin/uv ]; then
    export PATH="$HOME/.local/bin:$PATH"
    export PATH="$(dirname $(uv run which python)):$PATH"
    alias ipython='uvx --with $(\ls -m ~/.cache/uv/wheels-v5/pypi | tr -d " " | tr -d "\n") ipython'
fi


################
# General 'nix #
################
alias fcp="\\cp"
alias cp="cp -i -p"
alias rcp="rsync -naPhut"
alias frcp="rsync -aPhut"
alias fmv="\\mv"
alias mv="mv -i"
alias ..='cd ..'
alias grep='grep --color=always'
alias grepnc='grep --color=never'
alias less='less -cP "Press \"v\" to edit in vim, or \"s\" to save to file\.\.\."'
alias todo='echo "TODO: $*" >> ~/.TODO'
alias todos='less -p TODO ~/.TODO'
alias squash='sed -lE "s/$/`printf \"\x1b\x5b\x4b\x0d\"`/" | tr -ud "\n" && echo ""'
which nvim &> /dev/null \
    && alias vim="`which nvim`"
alias rg="rg --color=always --no-heading --hidden -g '!.git/' --smart-case"
alias rgnc="rg --color=never"
rgf() {
    rg --line-number "${*:-}" |
      fzf --ansi --delimiter : --bind 'enter:become(nvim {1} +{2} +"set nofoldenable")'
}


#######
# Git #
#######
if which git &> /dev/null; then
    #aliases
    alias gita='git add'
    alias gitb='git branch'
    alias gitc='git commit'
    alias gitd='git diff'
    alias gitds='git diff --stat'
    alias gitdt='git difftool'
    alias gitl='git log --oneline --graph --decorate'
    alias gitls='git log --stat'
    alias gitco='git checkout'
    alias gits='git status --short --branch'
    alias gitst='git stash'

    #functions
    alias gitss='git status $* | grep -v "^#$" | grep -v "^$" | grep -v "(use \"git" | sed -E "s/(On branch )(.*)$/\1$RED\2$RESET/"'
    alias gitstl='git stash list | sed -E "s/(stash\@\{.*\}:)(.*)$/$BLUE\1$YELLOW\2$RESET/"'
    alias gitsha='for sha in $(git log --pretty=format:%H master..); do git show $sha; done'
    alias gitu='git shortlog | grep --color=no -E "^[^ ]" | sed -E "s/:$//"'
    alias gitcs='open https://github.com/tiimgreen/github-cheat-sheet'
    # https://hackernoon.com/lesser-known-git-commands-151a1918a60
fi


###################
# Pretty-Printing #
###################
which cxxd &> /dev/null \
    && alias cxxd='cxxd -u -R 5'
which pygmentize &> /dev/null \
    && alias pcat='pygmentize -f terminal256 -O style=native -g'
xmlshow() {
    cat $@ \
        | xmllint --format - \
        | pcat
}
csvshow() {
    cat $@ \
        | sed -e 's/,,/, ,/g' \
        | column -s, -t \
        | less -rNS#5
}
tsvshow() {
    cat $@ \
        | column -s "	" -t \
        | less -rNS#5
}
cdiff() {
    diff $@ \
        | sed -E "s/(^< .*$)/$RED\1$RESET/" \
        | sed -E "s/(^> .*$)/$GREEN\1$RESET/" \
        | sed -E "s/^---$/$BLUE---$RESET/"
}


#######
# OSX #
#######
if [ 'Darwin' = $(uname) ]; then
    # General
    alias ls='ls -GF'
    alias lsr='CLICOLOR_FORCE=1 ls -Alt | head'

    # App Aliases
    [ -e /Applications/VLC.app/Contents/MacOS/VLC ] \
        && alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'
    [ -e /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl ] \
        && alias sublime='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'

    # Peripherals
    lockscreen() {
        exec /System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend &
    }
    alias lock='lockscreen'
    vol() {
        if [[ -n $1 ]]; then
            osascript -e 'set volume output muted false'
            osascript -e "set volume output volume $1"
        elif [[ `osascript -e 'output muted of (get volume settings)'` = 'true' ]]; then
            echo "muted"
        else
            osascript -e "output volume of (get volume settings)"
        fi
    }
    mute() {
        osascript -e 'set volume output muted true'
        echo "muted"
    }
fi


#########
# Linux #
#########
if [ 'Linux' = $(uname) ]; then
    alias ls='ls --color=always'
    alias lsr='CLICOLOR_FORCE=1 ls -altr | tac | head'

    # Peripherals
    vol() {
        if [[ -n $1 ]]; then
            amixer -q set Master unmute
            amixer set Master "$1"% | grep -E "\[on\]"
        else
            amixer get Master | grep -E "\[off\]|\[on\]"
        fi
    }
    mute() {
        amixer set Master mute | grep -E "\[off\]"
    }
fi


#########
# Music #
#########
if [ -e ~/Music/managed/beets/config.yaml ]; then
    export BEETSDIR=~/Music/managed/beets/
fi
if [ -e ~/Documents/android-platform-tools/adb ]; then
    export PATH="$PATH:$HOME/Documents/android-platform-tools"
fi
spec() {
    # Generate Spectrogram
    echo "$1" > /tmp/service_genspec.log
    rm -f /tmp/spectrogram.wav
    case "${1##*.}" in
      mp3|flac|wav)
        /opt/homebrew/bin/sox "$1" -n spectrogram -o /tmp/spectrogram.png && open /tmp/spectrogram.png
        ;;
      m4a|opus)
        /opt/homebrew/bin/ffmpeg -hide_banner -loglevel warning -i "$1" -c:a pcm_s24le /tmp/spectrogram.wav && \
            /opt/homebrew/bin/sox /tmp/spectrogram.wav -n spectrogram -o /tmp/spectrogram.png && open /tmp/spectrogram.png
        ;;
      *)
        osascript -e "display notification \"sox: Unknown audio filetype\""
        echo "sox: Unknown audio filetype for $1" >> /tmp/service_genspec.log
        ;;
    esac
}
spec_diff() {
    rm -f /tmp/spectrogram1.wav /tmp/spectrogram2.wav
    /opt/homebrew/bin/ffmpeg -hide_banner -loglevel warning -i "$1" -c:a pcm_s24le /tmp/spectrogram1.wav
    /opt/homebrew/bin/ffmpeg -hide_banner -loglevel warning -i "$2" -c:a pcm_s24le /tmp/spectrogram2.wav
    /opt/homebrew/bin/sox /tmp/spectrogram1.wav -n spectrogram -o /tmp/spectrogram1.png
    /opt/homebrew/bin/sox /tmp/spectrogram2.wav -n spectrogram -o /tmp/spectrogram2.png
    diff /tmp/spectrogram1.png /tmp/spectrogram2.png
}
extract_art() {
    # Extract Art
    echo "$1" > /tmp/service_extractart.log
    rm -f /tmp/extractedart.png
    /opt/homebrew/bin/ffmpeg -hide_banner -loglevel warning -i "$1" -map 0:v -map -0:V -c copy /tmp/extractedart.png && open /tmp/extractedart.png
}
ffprobe_report() {
    # Report ffprobe
    echo "$1" > /tmp/service_ffprobe.log
    /opt/homebrew/bin/ffprobe "$1" &> /tmp/service_ffprobe.log && open /tmp/service_ffprobe.log
}


ssh_audit() {
    (
        gunzip -c /var/log/system.log.*.gz | rg sshd
        rg sshd /var/log/system.log
    ) | sort
}
