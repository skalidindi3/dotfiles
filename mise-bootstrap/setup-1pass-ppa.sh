#!/usr/bin/env bash
set -euo pipefail

if [ "$(uname -s)" = Linux ] && command -v apt-get >/dev/null; then
  key=$(mktemp)
  trap 'rm -f "$key"' EXIT
  curl -fsSL https://downloads.1password.com/linux/keys/1password.asc -o "$key"
  sudo install -Dm644 "$key" /usr/share/keyrings/1password-archive-keyring.asc
  arch=$(dpkg --print-architecture)
  echo "deb [arch=$arch signed-by=/usr/share/keyrings/1password-archive-keyring.asc] https://downloads.1password.com/linux/debian/$arch stable main" |
    sudo tee /etc/apt/sources.list.d/1password.list >/dev/null
fi
