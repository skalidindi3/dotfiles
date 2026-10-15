# Shared PATH setup runs in every zsh session, including SSH commands.
# .bash_aliases guards the remaining setup so it only runs interactively.
if [ -f "$HOME/.bash_aliases" ]; then
    . "$HOME/.bash_aliases"
fi
