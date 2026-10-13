#!/usr/bin/env bash
set -euo pipefail

for dependency in ssh-keygen gh awk; do
    if ! command -v "$dependency" >/dev/null 2>&1; then
        printf 'Required command not found: %s\n' "$dependency" >&2
        exit 1
    fi
done

KEY_HOSTNAME=$1
KEY_EMAIL="skalidindi3@gmail.com"
KEY_DIR="./generated_keys"
PRIVATE_KEY="$KEY_DIR/$KEY_HOSTNAME"
PUBLIC_KEY="$PRIVATE_KEY.pub"

if [[ $# -ne 1 ]]; then
    printf 'Usage: %s <hostname>\n' "${0##*/}" >&2
    exit 2
fi

if ! gh api --hostname github.com --include user 2>/dev/null |
    awk '
        tolower($1) == "x-oauth-scopes:" &&
        /[[:space:],](write|admin):public_key([[:space:],]|$)/ { ok = 1 }
        END { exit !ok }
    '; then
    echo 'Missing key-upload permission. Run: gh auth refresh -h github.com -s write:public_key' >&2
    exit 1
fi

for key_file in "$PRIVATE_KEY" "$PUBLIC_KEY"; do
    if [[ -e "$key_file" || -L "$key_file" ]]; then
        printf 'Refusing to overwrite existing path: %s\n' "$key_file" >&2
        exit 1
    fi
done

umask 077
mkdir -p -- "$KEY_DIR"
ssh-keygen -t ed25519 -N "" -f "$PRIVATE_KEY" -C "$KEY_EMAIL $KEY_HOSTNAME"

if ! GH_HOST=github.com gh ssh-key add "$PUBLIC_KEY" --title "$KEY_HOSTNAME" --type authentication; then
    echo 'Upload failed; both generated key files have been preserved.' >&2
    exit 1
fi

printf 'Created %s and %s; registered the public key with GitHub.\n' "$PRIVATE_KEY" "$PUBLIC_KEY"
