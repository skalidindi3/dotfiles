# Bash also reads this for SSH commands: set PATH before the interactive guard.
. "$HOME/.config/shell/env.sh"
case $- in
    *i*) ;;
    *) return 0 ;;
esac
. "$HOME/.config/shell/interactive.sh"
. "$HOME/.config/shell/interactive.bash"
