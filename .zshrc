# Explicitly set SHELL, TERM, EDITOR
export SHELL="`which zsh`"
export TERM="xterm-256color"
export EDITOR='nvim'

export HISTFILE="$HOME/.cache/zsh/zsh_history"
export HISTSIZE=100000
export HISTFILESIZE=$HISTSIZE
export SAVEHIST=$HISTSIZE
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Key-bindings                                      # ensure that zsh+tmux combo keeps emacs bindings
bindkey -e
# OSX convenience                                   # iTerm2 default    # OSX default   # Keys
# ------------                                      # --------------    # -----------   # ----
bindkey '^R'   history-incremental-search-backward  # true              # true          # ctrl + R
bindkey '^[[Z' reverse-menu-complete                # true              # true          # shift + TAB
bindkey "^[OH" beginning-of-line                    # true              # false         # Fn + <--
bindkey "^[OF" end-of-line                          # true              # false         # Fn + -->
bindkey "^[b"  backward-word                        # false             # false         # option + left arrow
bindkey "^[f"  forward-word                         # false             # false         # option + right arrow
bindkey "^H"   backward-delete-word                 # false             # false         # option + delete

# Interactive shell
setopt interactivecomments

# Modify interactive shell word delimiters (for movement and backward-kill-word)
export WORDCHARS=${WORDCHARS:s#/#}                  # count '/' as delimiter
export WORDCHARS=${WORDCHARS:s#-#}                  # count '-' as delimiter
export WORDCHARS=${WORDCHARS:s#_#}                  # count '_' as delimiter

# Enable zsh colors
autoload -Uz colors && colors

# Prompt setup
setopt PROMPT_SUBST                                 # allow for prompt expansion
PROMPT='%F{180}$( [[ -z "$HISTFILE" ]] && echo "(nohist) " )'
PROMPT+='%(?.%F{32}.%F{196})'                       # if last exit code == 0, set fg color blue (32), else red (196)
PROMPT+='%1~ '                                      # current dir name only, with home as '~'
PROMPT+='ϟ '                                        # custom prompt symbol
PROMPT+='%f%k'                                      # end foreground & background coloring

# Report CPU usage for commands running longer than 30 seconds
TIMEFMT=$'\n\n'"$fg[blue]%J$reset_color :: $fg[yellow]%U user, %S system, %P cpu, %*E total, %M KiB$reset_color"
REPORTTIME=30

# Completion
FPATH="$HOME/.config/zsh/completions/:$FPATH"
autoload -U compinit && compinit                    # fire up completion base module
setopt always_to_end                                # when completing from middle of word, move cursor to the end
setopt list_ambiguous                               # complete as much as possible (until it gets ambiguous)
setopt glob_complete                                # expanding globs into completion list
unsetopt correct_all                                # don't over-correct (don't assume file names, etc)
setopt correct                                      # only correct command names
zstyle ':completion:*' completer _expand _complete  # expand globs and path strings before completing
zstyle ':completion:*' menu select=2                # loads zsh/complist, uses completion menu for >= 2 matches
zstyle ':completion:*' group-name ''                # set group name to name of tag
zstyle ':completion:*' list-dirs-first true         # group completions, cycle directories first
zstyle ':completion:*:processes' \
  command 'ps -au$USER'                             # complete current running processes for `kill`

# Source custom aliases and colors
if [[ -f ~/.bash_aliases ]]; then
    source ~/.bash_aliases
fi
if [[ -d ~/dotfiles/private/sourceable ]]; then
    for extra_env in ~/dotfiles/private/sourceable/*; do
        source $extra_env
    done
fi

# Completion Coloring
if [[ -n $LS_COLORS ]]; then                        # use `ls` coloring for path completion list
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi
zstyle ':completion:*:*:kill:*' list-colors \
  '=(#b) #([0-9]#)*( *[a-z])*=34=31=33'             # set coloring for kill completion list

# fzf
# arcticicestudio/nord-vim
export FZF_DEFAULT_OPTS='--color=bg+:#3B4252,bg:#2E3440,spinner:#81A1C1,hl:#616E88,fg:#D8DEE9,header:#616E88,info:#81A1C1,pointer:#81A1C1,marker:#81A1C1,fg+:#D8DEE9,prompt:#81A1C1,hl+:#81A1C1'
export FZF_COMPLETION_TRIGGER=','
if command -v which fzf &> /dev/null; then
    if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
        source /usr/share/doc/fzf/examples/key-bindings.zsh
        source /usr/share/doc/fzf/examples/completion.zsh
    else
        source $(dirname $(dirname $(realpath $(which fzf))))/shell/key-bindings.zsh
        source $(dirname $(dirname $(realpath $(which fzf))))/shell/completion.zsh
    fi
fi

# antidote
if [[ -f /opt/homebrew/opt/antidote/share/antidote/antidote.zsh ]]; then
    source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
    [[ -f ~/.zsh_plugins.txt ]] && antidote load
fi
if [[ -f /usr/share/zsh-antidote/antidote.zsh ]]; then
    source /usr/share/zsh-antidote/antidote.zsh
    [[ -f ~/.zsh_plugins.txt ]] && antidote load
fi

