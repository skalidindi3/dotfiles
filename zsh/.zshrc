# Source custom aliases and colors
[[ -f ~/.bash_aliases ]] \
    && source ~/.bash_aliases

# Key-bindings                                      # iTerm2 default    # OSX default   # Keys
# ------------                                      # --------------    # -----------   # ----
bindkey '^R'   history-incremental-search-backward  # true              # true          # ctrl + R
bindkey '^[[Z' reverse-menu-complete                # true              # true          # shift + TAB
bindkey "^[OH" beginning-of-line                    # true              # false         # Fn + <--
bindkey "^[OF" end-of-line                          # true              # false         # Fn + -->
bindkey "^[b"  backward-word                        # false             # false         # option + left arrow
bindkey "^[f"  forward-word                         # false             # false         # option + right arrow
bindkey "^H"   backward-delete-word                 # false             # false         # option + delete

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
RPROMPT='%F{8}'                                     # set foreground color gray (8)
RPROMPT+='[%D{%T}]'                                 # datetime string formatted as 24-hour time (with seconds)
RPROMPT+='%f%k'                                     # end foreground & background coloring
#preexec() { print -P $RPROMPT }                    # useful for timing commands

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
if [[ -n $LSCOLORS ]]; then                         # use `ls` coloring for completion list
    zstyle ':completion:*' list-colors ${(s.:.)LSCOLORS}    # OSX compat
elif [[ -n $LS_COLORS ]]; then
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}   # Linux compat
fi

# Antigen
if [[ -f ~/dotfiles/antigen/antigen.zsh ]]; then
    source ~/dotfiles/antigen/antigen.zsh
    antigen bundle zsh-users/zsh-syntax-highlighting
    antigen bundle supercrabtree/k
    antigen apply
fi

