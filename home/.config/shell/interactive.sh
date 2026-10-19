# Shared interactive settings for Bash and Zsh; env.sh must be sourced first.
[ "${_dotfiles_interactive_loaded-}" = "$$" ] && return 0
# Keep the guard out of child environments so each shell initializes itself.
typeset +x _dotfiles_interactive_loaded=$$

# Activate mise before checking for installed tools.
if command -v mise >/dev/null 2>&1; then
    if [ -n "${ZSH_VERSION-}" ]; then
        eval "$(mise activate zsh)"
    else
        eval "$(mise activate bash)"
    fi
fi

# Editor
if command -v nvim >/dev/null 2>&1; then
    alias vi=nvim
    alias vim=nvim
    export MANPAGER='nvim +Man!'
fi

# Colors
RED=$'\033[1;31m'
GREEN=$'\033[1;32m'
BLUE=$'\033[1;34m'
YELLOW=$'\033[0;33m'
RESET=$'\033[0m'
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
    local x y z c i j
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
    printf "Standard 16 colors\n"
    for ((c = 0; c < 16; c++)); do
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

# Folders
cdp() { cd "${HOME}/Documents/projects/$@"; }

# Python
ipython() {
    command uvx \
        --with $(\ls -m ~/.cache/uv/wheels-v5/pypi \
            | tr -d " " \
            | tr -d "\n") \
        ipython "$@"
}

# General 'nix
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
todo() { printf 'TODO: %s\n' "$*" >> "$HOME/.TODO"; }
alias todos='less -p TODO ~/.TODO'
alias squash='sed -lE "s/$/`printf \"\x1b\x5b\x4b\x0d\"`/" | tr -ud "\n" && echo ""'
alias rg="rg --color=always --no-heading --hidden -g '!.git/' --smart-case"
alias rgnc="rg --color=never"
rgf() {
    [ "$#" -gt 0 ] || set -- ''
    command rg --color=always --no-heading --hidden -g '!.git/' --smart-case --line-number "$@" |
      command fzf --ansi --delimiter : --bind 'enter:become(nvim {1} +{2} +"set nofoldenable")'
}

# Platform defaults; lsd overrides the listing helpers when available.
case $(uname -s) in
    Darwin)
        alias ls='ls -GF'
        alias lsr='CLICOLOR_FORCE=1 ls -Alt | head'
        [ -e /Applications/VLC.app/Contents/MacOS/VLC ] &&
            alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'
        lockscreen() {
            exec /System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend &
        }
        ;;
    Linux)
        alias ls='ls --color=always'
        alias lsr='CLICOLOR_FORCE=1 ls -altr | tac | head'
        ;;
esac
if command -v lsd >/dev/null 2>&1; then
    alias lsl="lsd -I \.git -al --group-directories-first"
    alias ll=lsl
    alias lsr="lsd -I \.git -Alt --color always | head"
    alias tree="lsd -I \.git --tree"
fi

# Git
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

gitss() {
    command git status "$@" |
        command grep --color=never -v -e '^#$' -e '^$' -e '(use "git' |
        sed -E "s/(On branch )(.*)$/\1$RED\2$RESET/"
}
gitstl() {
    command git stash list "$@" |
        sed -E "s/(stash@\{.*\}:)(.*)$/$BLUE\1$YELLOW\2$RESET/"
}
gitsha() {
    local sha
    command git log --format=%H master.. |
        while IFS= read -r sha; do command git show "$sha"; done
}
gitu() {
    command git shortlog "$@" | command grep --color=never -E '^[^ ]' | sed -E 's/:$//'
}
gitcs() { _dotfiles_open https://github.com/tiimgreen/github-cheat-sheet; }

# Pretty-printing
alias cxxd='cxxd -u -R 5'
alias pcat='pygmentize -f terminal256 -O style=native -g'
xmlshow() {
    cat "$@" | xmllint --format - | pcat
}
csvshow() {
    cat "$@" | sed -e 's/,,/, ,/g' | column -s, -t | less -rNS#5
}
tsvshow() {
    cat "$@" | column -s "	" -t | less -rNS#5
}
cdiff() {
    diff "$@" | sed -E \
        -e "s/(^< .*$)/$RED\1$RESET/" \
        -e "s/(^> .*$)/$GREEN\1$RESET/" \
        -e "s/^---$/$BLUE---$RESET/"
}

# Music
# Open a generated artifact, or report its location on a headless machine.
_dotfiles_open() {
    case $(uname -s) in
        Darwin)
            if command -v open >/dev/null 2>&1; then
                command open "$@"
                return
            fi
            ;;
        Linux)
            if [ -n "${DISPLAY-}${WAYLAND_DISPLAY-}" ] && command -v xdg-open >/dev/null 2>&1; then
                command xdg-open "$@"
                return
            fi
            ;;
    esac
    printf '%s\n' "$@"
}
spec() {
    # Generate Spectrogram
    printf '%s\n' "$1" > /tmp/service_genspec.log
    rm -f /tmp/spectrogram.wav
    case "${1##*.}" in
      mp3|flac|wav)
        command sox "$1" -n spectrogram -o /tmp/spectrogram.png && _dotfiles_open /tmp/spectrogram.png
        ;;
      m4a|opus)
        command ffmpeg -hide_banner -loglevel quiet -i "$1" -c:a pcm_s24le /tmp/spectrogram.wav && \
            command sox /tmp/spectrogram.wav -n spectrogram -o /tmp/spectrogram.png && _dotfiles_open /tmp/spectrogram.png
        ;;
      *)
        if [ "$(uname -s)" = Darwin ] && command -v osascript >/dev/null 2>&1; then
            command osascript -e 'display notification "sox: Unknown audio filetype"'
        fi
        printf 'sox: Unknown audio filetype for %s\n' "$1" >> /tmp/service_genspec.log
        printf 'sox: Unknown audio filetype for %s\n' "$1" >&2
        return 1
        ;;
    esac
}
spec_diff() {
    rm -f /tmp/spectrogram1.wav /tmp/spectrogram2.wav
    command ffmpeg -hide_banner -loglevel quiet -i "$1" -c:a pcm_s24le /tmp/spectrogram1.wav &&
    command ffmpeg -hide_banner -loglevel quiet -i "$2" -c:a pcm_s24le /tmp/spectrogram2.wav &&
    command sox /tmp/spectrogram1.wav -n spectrogram -o /tmp/spectrogram1.png &&
    command sox /tmp/spectrogram2.wav -n spectrogram -o /tmp/spectrogram2.png &&
    diff /tmp/spectrogram1.png /tmp/spectrogram2.png
}
extract_art() {
    # Extract Art
    printf '%s\n' "$1" > /tmp/service_extractart.log
    rm -f /tmp/extractedart.png
    command ffmpeg -hide_banner -loglevel quiet -i "$1" -map 0:v -map -0:V -c copy /tmp/extractedart.png && _dotfiles_open /tmp/extractedart.png
}
ffprobe_report() {
    # Report ffprobe
    printf '%s\n' "$1" > /tmp/service_ffprobe.log
    command ffprobe "$1" > /tmp/service_ffprobe.log 2>&1 && _dotfiles_open /tmp/service_ffprobe.log
}

# Video
ass2srt() {
    mv "$1" "${1/mkv/orig.mkv}"
    ffmpeg -i "${1/mkv/orig.mkv}" -c copy -c:s srt "$1"
}
ac32aac() {
    mv "$1" "${1/mkv/orig.mkv}"
    ffmpeg -i "${1/mkv/orig.mkv}" -map 0 -c:v copy -c:s copy -c:a aac -ac 2 -b:a 224k "$1"
}

ssh_audit() {
    (
        gunzip -c /var/log/system.log.*.gz | rg sshd
        rg sshd /var/log/system.log
    ) | sort
}

# Shared fzf preferences; shell-specific integrations are loaded afterward.
export FZF_DEFAULT_OPTS='--color=bg+:#3B4252,bg:#2E3440,spinner:#81A1C1,hl:#616E88,fg:#D8DEE9,header:#616E88,info:#81A1C1,pointer:#81A1C1,marker:#81A1C1,fg+:#D8DEE9,prompt:#81A1C1,hl+:#81A1C1'
export FZF_COMPLETION_TRIGGER=','
return 0
