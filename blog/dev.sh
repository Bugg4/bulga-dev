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

typst-git watch dist.typ \
  --root . \
  --format bundle \
  --features bundle,html \
  --ignore-system-fonts \
  --no-serve \
  --no-reload