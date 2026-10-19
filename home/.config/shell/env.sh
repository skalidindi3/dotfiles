# Shared environment for sh, Bash, and Zsh; no external commands or output.

# Move a directory to the front (or append it), dropping its old occurrences
# and empty entries. This keeps repeated startup sourcing from growing PATH.
path_add() {
    _path_rest="${PATH-}:"
    _path_clean=
    while [ -n "$_path_rest" ]; do
        _path_entry=${_path_rest%%:*}
        _path_rest=${_path_rest#*:}
        if [ -n "$_path_entry" ] && [ "$_path_entry" != "$1" ]; then
            _path_clean="${_path_clean:+$_path_clean:}$_path_entry"
        fi
    done
    if [ "${2-}" = append ]; then
        PATH="${_path_clean:+$_path_clean:}$1"
    else
        PATH="$1${_path_clean:+:$_path_clean}"
    fi
}

# Mise package directories, followed by higher-priority user tools and shims.
for _path_dir in \
    '/home/linuxbrew/.linuxbrew/sbin' '/home/linuxbrew/.linuxbrew/bin' \
    '/opt/homebrew/sbin' '/opt/homebrew/bin'; do
    if [ -d "$_path_dir" ]; then
        path_add "$_path_dir"
    fi
done
path_add "$HOME/.local/bin"
_mise_data=${MISE_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/mise}
path_add "${MISE_SHIMS_DIR:-$_mise_data/shims}"

# Keep the legacy Android tools as a last-resort fallback.
if [ -f "$HOME/Documents/android-platform-tools/adb" ]; then
    path_add "$HOME/Documents/android-platform-tools" append
fi
export PATH
unset -f path_add
unset _path_rest _path_entry _path_clean _path_dir _mise_data

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
if [ -f "$HOME/Music/managed/beets/config.yaml" ]; then
    export BEETSDIR="${BEETSDIR:-$HOME/Music/managed/beets/}"
fi
