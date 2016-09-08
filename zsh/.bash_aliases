# Color Codes
RED=$(printf "\x1b[1;31m")
GREEN=$(printf "\x1b[1;32m")
BLUE=$(printf "\x1b[1;34m")
YELLOW=$(printf "\x1b[1;33m")
RESET=$(printf "\x1b[0m")


##########
# Colors #
##########
export LSCOLORS='ExDxxxxxCxxxgxxxxxExEx'
export LESS_TERMCAP_us=$'\033[04;38;5;215m' # man page coloring
export LESS_TERMCAP_ue=$'\033[0m'
export LESS_TERMCAP_md=$'\033[01;38;5;74m'
export LESS_TERMCAP_me=$'\033[0m'
function show_colors() {
  echo -e "\033[0;30mBLACK\t\033[1;37mWHITE"
  echo -e "\033[0;34mBLUE\t\033[1;34mLIGHT_BLUE"
  echo -e "\033[0;32mGREEN\t\033[1;32mLIGHT_GREEN"
  echo -e "\033[0;36mCYAN\t\033[1;36mLIGHT_CYAN"
  echo -e "\033[0;31mRED\t\033[1;31mLIGHT_RED"
  echo -e "\033[0;35mPURPLE\t\033[1;35mLIGHT_PURPLE"
  echo -e "\033[0;33mYELLOW\t\033[1;33mLIGHT_YELLOW"
  echo -e "\033[1;30mGRAY\t\033[0;37mLIGHT_GRAY"
  echo -e "\033[0mRESET"
}
alias strip_colors="perl -pe 's/\e\[?.*?[\@-~]//g'"


###################
# Pretty-Printing #
###################
which pygmentize &> /dev/null \
  && alias pcat='pygmentize -f terminal256 -O style=native -g'
function xmlshow() {
  cat $@ \
    | xmllint --format - \
    | pcat
}
function csvshow() {
  cat $@ \
    | sed -e 's/,,/, ,/g' \
    | column -s, -t \
    | less -rNS#5
}
function tsvshow() {
  cat $@ \
    | column -s "	" -t \
    | less -rNS#5
}
function cdiff() {
  diff $@ \
    | sed -E "s/(^< .*$)/$RED\1$RESET/" \
    | sed -E "s/(^> .*$)/$GREEN\1$RESET/" \
    | sed -E "s/^---$/$BLUE---$RESET/"
}

#############
# MP3 Utils #
#############
function spec() {
    sox "$@" -n spectrogram && open ./spectrogram.png
}
function all2mp3() {
    ffmpeg -i "$1" -ab 320k -map_metadata 0 -id3v2_version 3 "${1}.mp3"
}


################
# General 'nix #
################
alias ..='cd ..'
alias grep='grep --color=always'
alias grepnc='grep --color=never'
alias pls='sudo !!'
alias j='jobs'
alias more='more -r'
alias less='less -cP "Press \"v\" to edit in vim, or \"s\" to save to file\.\.\."'
alias lsr='CLICOLOR_FORCE=1 ls -altr | tail -r | head'
alias vless='/usr/share/vim/vim73/macros/less.sh'
alias todo='echo "TODO: $*" >> ~/.TODO'
alias todos='less -p TODO ~/.TODO'
alias squash='sed -lE "s/$/`printf \"\x1b\x5b\x4b\x0d\"`/" | tr -ud "\n" && echo ""'
alias cxxd='cxxd -u -R 5'
cpp () {
    rsync -ah --progress "$1" "$2"
}
# Calculations
function _calc() {
  echo "$@" | bc
}
alias calc='noglob _calc'
# Prefer neovim
unalias vim &> /dev/null
which vim &> /dev/null \
  && alias ovim="`which vim`"
which nvim &> /dev/null \
  && alias vim="`which nvim`"


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
  alias gitst='git stash'

  #functions
  alias gits='git status $* | grep -v "^#$" | grep -v "^$" | grep -v "(use \"git" | sed -E "s/(On branch )(.*)$/\1$RED\2$RESET/"'
  alias gitss='git status --short'
  alias gitstl='git stash list | sed -E "s/(stash\@\{.*\}:)(.*)$/$BLUE\1$YELLOW\2$RESET/"'
  alias gitsha='for sha in $(git log --pretty=format:%H master..); do git show $sha; done'
  alias gitcs='open https://github.com/tiimgreen/github-cheat-sheet'
  alias gitu='git shortlog | grep --color=no -E "^[^ ]" | sed -E "s/:$//"'

  # allow git completions for aliases
  if [ -n "$ZSH_VERSION" ]; then
    compdef _git gita=git-add
    compdef _git gitb=git-branch
    compdef _git gitc=git-commit
    compdef _git gitd=git-diff
    compdef _git gitds=git-diff
    compdef _git gitdt=git-difftool
    compdef _git gitl=git-log
    compdef _git gitls=git-log
    compdef _git gitco=git-checkout
    compdef _git gitst=git-stash
  fi
fi


###########
# Vagrant #
###########
if which vagrant &> /dev/null; then
    vssh() {
        vagrant ssh-config &> /dev/null \
            || vagrant up
        vagrant ssh
    }
    alias vh='vagrant halt'
    alias vd='vagrant destroy'
fi


#######
# OSX #
#######
if [ 'Darwin' = $(uname) ]; then
  # General
  alias ls='ls -GF'

  # App Aliases
  which mvim &> /dev/null \
    && alias vim='mvim -v'
  [ -e /Applications/VLC.app/Contents/MacOS/VLC ] \
    && alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'
  [ -e /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl ] \
    && alias sublime='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'

  # Folders
  [ -e ~/Documents/vagrant ] \
    && cdv() { cd "/Users/`whoami`/Documents/vagrant/$@"; }
  [ -e ~/Documents/transcriptic ] \
    && cdt() { cd "/Users/`whoami`/Documents/transcriptic/$@"; }
  [ -e ~/Documents/projects ] \
    && cdp() { cd "/Users/`whoami`/Documents/projects/$@"; }

  # Brew Git Completion
  [ -f $(brew --prefix)/etc/bash_completion ] \
    && source $(brew --prefix)/etc/bash_completion

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
  alias m='mute'
fi


#########
# Linux #
#########
if [ 'Linux' = $(uname) ]; then
  alias ls='ls --color=always'
  # OpenOCD Aliases
  which openocd &> /dev/null \
    && alias link_discovery='sudo openocd -f board/stm32f4discovery.cfg'
  which openocd &> /dev/null \
    && alias link_stm='sudo openocd -f interface/stlink-v2.cfg -f target/stm32f4x_stlink.cfg'
fi


###########
# Exports #
###########
export BC_ENV_ARGS=~/.bcrc
export HISTCONTROL=ignorespace:ignoredups
export HISTTIMEFORMAT='%F %T '


# TODO: https://robots.thoughtbot.com/autosquashing-git-commits
# TODO: http://atechnicaltravesty.blogspot.com/2011/05/custom-tab-complete-and-bash-functions.html
# TODO info function
# i() { which & type }

