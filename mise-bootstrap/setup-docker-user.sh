#!/usr/bin/env bash
set -euo pipefail

if [ "$(uname -s)" = Linux ] && command -v apt-get >/dev/null; then
  getent group docker >/dev/null || sudo groupadd docker
  sudo usermod -aG docker "$(id -un)"
  echo "Log out and back in to activate Docker group membership."
fi
