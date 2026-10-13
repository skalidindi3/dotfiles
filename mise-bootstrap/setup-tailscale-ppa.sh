#!/usr/bin/env bash
set -euo pipefail

if [ "$(uname -s)" = Linux ] && command -v apt-get >/dev/null; then
  # shellcheck source=/dev/null
  . /etc/os-release
  case "$ID" in
    ubuntu|debian) ;;
    *) echo "Tailscale repository setup requires Ubuntu or Debian" >&2; exit 1 ;;
  esac

  base="https://pkgs.tailscale.com/stable/$ID/${VERSION_CODENAME:?Missing distribution codename}"
  temp_dir=$(mktemp -d)
  trap 'rm -rf "$temp_dir"' EXIT
  curl -fsSL "$base.noarmor.gpg" -o "$temp_dir/key.gpg"
  curl -fsSL "$base.tailscale-keyring.list" -o "$temp_dir/tailscale.list"
  sudo install -Dm644 "$temp_dir/key.gpg" /usr/share/keyrings/tailscale-archive-keyring.gpg
  sudo install -Dm644 "$temp_dir/tailscale.list" /etc/apt/sources.list.d/tailscale.list
fi
