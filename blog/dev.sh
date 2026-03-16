#!/bin/bash

typst-git watch dist.typ \
  --root . \
  --format bundle \
  --features bundle,html \
  --ignore-system-fonts \
  --no-serve \
  --no-reload &
live-server ./dist
