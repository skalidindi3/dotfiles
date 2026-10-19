if [ "${_dotfiles_bash_loaded-}" = "$$" ]; then
    return 0
fi
typeset +x _dotfiles_bash_loaded=$$

# Keep the conventional Bash history file and prompt, independent of Zsh.
typeset +x HISTFILE="$HOME/.bash_history" HISTSIZE=100000 HISTFILESIZE=100000
HISTCONTROL=ignoreboth
shopt -s histappend checkwinsize

if [ -z "${BASH_COMPLETION_VERSINFO-}" ]; then
    if [ -r /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -r /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi
if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --bash)"
fi
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init --cmd cd bash)"
fi
return 0
