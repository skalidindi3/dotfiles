[[ ${_dotfiles_zsh_loaded-} == $$ ]] && return 0
typeset +x _dotfiles_zsh_loaded=$$

# History belongs to this shell; never pass Zsh's history path to Bash.
typeset +x HISTFILE="$HOME/.cache/zsh/zsh_history" HISTSIZE=100000 SAVEHIST=100000
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
bindkey '^[[H' beginning-of-line                    # normal-mode Home
bindkey '^[[F' end-of-line                          # normal-mode End
bindkey "^[b"  backward-word                        # false             # false         # option + left arrow
bindkey "^[f"  forward-word                         # false             # false         # option + right arrow
bindkey "^H"   backward-delete-word                 # false             # false         # option + delete

# Interactive shell
setopt interactivecomments

# Modify interactive shell word delimiters (for movement and backward-kill-word)
WORDCHARS=${WORDCHARS:s#/#}                        # count '/' as delimiter
WORDCHARS=${WORDCHARS:s#-#}                        # count '-' as delimiter
WORDCHARS=${WORDCHARS:s#_#}                        # count '_' as delimiter

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
typeset -U fpath
for _dotfiles_completion_dir in \
    '/home/linuxbrew/.linuxbrew/share/zsh/site-functions' \
    '/opt/homebrew/share/zsh/site-functions'; do
    [[ -d $_dotfiles_completion_dir ]] && fpath=("$_dotfiles_completion_dir" $fpath)
done
unset _dotfiles_completion_dir
fpath=("$HOME/.config/zsh/completions" $fpath)
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

# Completion Coloring
if [[ -n ${LS_COLORS-} ]]; then                     # use `ls` coloring for path completion list
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi
zstyle ':completion:*:*:kill:*' list-colors \
  '=(#b) #([0-9]#)*( *[a-z])*=34=31=33'             # set coloring for kill completion list

# Keep private settings interactive and Zsh-only. (N) permits an empty directory.
for _dotfiles_private in "$HOME"/dotfiles/private/sourceable/*(N); do
    [[ -f $_dotfiles_private && -r $_dotfiles_private ]] && source "$_dotfiles_private"
done
unset _dotfiles_private

if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
fi
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init --cmd cd zsh)"
fi
if (( $+functions[cdp] )); then
    compctl -W "$HOME/Documents/projects" -/ cdp
fi

# Antidote follows completion integrations. The plugin list puts highlighting last.
if command -v mise >/dev/null 2>&1; then
    if _dotfiles_antidote_prefix=$(mise bootstrap packages where brew:antidote 2>/dev/null); then
        _dotfiles_antidote_script="$_dotfiles_antidote_prefix/share/antidote/antidote.zsh"
        if [[ -r $_dotfiles_antidote_script ]]; then
            source "$_dotfiles_antidote_script"
            [[ -r "$HOME/.zsh_plugins.txt" ]] && antidote load "$HOME/.zsh_plugins.txt"
        fi
    fi
fi
unset _dotfiles_antidote_script _dotfiles_antidote_prefix
return 0

