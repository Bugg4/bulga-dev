#!/bin/bash

qr() {
  local input
  if [[ -n "$1" ]]; then
    input="$*"
  else
    input="$(cat)"
  fi
  qrencode -t UTF8 -o - "$input"
}
export -f qr

lanip() {
  ip -brief address show | grep -oP '192\.168\.\d+\.\d+' | head -n 1
}
export -f lanip

# Handle Args
if [ "$1" == "clean" ]; then
  echo "Cleaning dist ..."
  rm -rf "$DIST_DIR"
  echo "Cleaned."
  exit 0
fi

typst-git watch dist.typ \
  --root . \
  --format bundle \
  --features bundle,html \
  --ignore-system-fonts \
  --no-serve \
  --no-reload &
qr http://$(lanip):8080
live-server ./dist
