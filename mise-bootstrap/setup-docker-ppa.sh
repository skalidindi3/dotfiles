#!/usr/bin/env bash
set -euo pipefail

if [ "$(uname -s)" = Linux ] && command -v apt-get >/dev/null; then
  # shellcheck source=/dev/null
  . /etc/os-release
  [ "$ID" = ubuntu ] || {
    echo "Docker repository setup requires Ubuntu" >&2
    exit 1
  }

  temp_dir=$(mktemp -d)
  trap 'rm -rf "$temp_dir"' EXIT
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o "$temp_dir/docker.asc"
  cat > "$temp_dir/docker.sources" <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: ${UBUNTU_CODENAME:-$VERSION_CODENAME}
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
  sudo install -Dm644 "$temp_dir/docker.asc" /etc/apt/keyrings/docker.asc
  sudo install -Dm644 "$temp_dir/docker.sources" /etc/apt/sources.list.d/docker.sources
  sudo apt-get update
fi
