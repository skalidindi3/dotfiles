#!/usr/bin/env bash
set -euo pipefail

if [ "$(uname -s)" != Linux ]; then
  echo "Docker Engine checks apply to Linux only."
  exit 0
fi

sudo docker run --rm hello-world
sudo docker run --rm alpine ping -c 3 8.8.8.8
