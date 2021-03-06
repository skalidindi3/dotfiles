# Explicitly set SHELL, TERM, EDITOR
export SHELL="`which zsh`"
export TERM="xterm-256color"
export EDITOR='nvim'

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

# Prompt setup
setopt PROMPT_SUBST                                 # allow for prompt expansion
PROMPT='%(?.%F{32}.%F{196})'                        # if last exit code == 0, set fg color blue (32), else red (196)
PROMPT+='%1~ '                                      # current dir name only, with home as '~'
PROMPT+='ϟ '                                        # custom prompt symbol
PROMPT+='%f%k'                                      # end foreground & background coloring

# Completion
autoload -U compinit && compinit                    # fire up completion base module
setopt complete_aliases                             # complete alisases
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

# Completion Coloring
if [[ -n $LS_COLORS ]]; then                        # use `ls` coloring for path completion list
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi
zstyle ':completion:*:*:kill:*' list-colors \
  '=(#b) #([0-9]#)*( *[a-z])*=34=31=33'             # set coloring for kill completion list

# Antigen
if [[ -f ~/dotfiles/antigen/antigen.zsh ]]; then
    source ~/dotfiles/antigen/antigen.zsh
    antigen bundle zsh-users/zsh-syntax-highlighting
    antigen bundle supercrabtree/k
    antigen apply
fi

# Google
if [[ -f ~/.googlerc ]]; then
    source ~/.googlerc
fi

