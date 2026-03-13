#!/bin/bash

# Define colors using literal escape characters for better compatibility
BUILD_COLOR=$'\e[34m' # Blue
SERVER_COLOR=$'\e[32m' # Green
SYSTEM_COLOR=$'\e[33m' # Yellow

RESET_COLOR=$'\e[0m'

BUILD_PREFIX="Build "
SERVER_PREFIX="Server"
SYSTEM_PREFIX="System "

# Function to prefix output reliably with colors
prefix_output() {
  local prefix=$1
  local color=$2
  while read -r line; do
    printf "%s[%s]%s %s\n" "$color" "$prefix" "$RESET_COLOR" "$line"
  done
}

# Cleanup background processes on exit
cleanup() {
  echo -e "\n${SYSTEM_COLOR}[${SYSTEM_PREFIX}]${RESET_COLOR} Stopping background processes..."
  pkill -P $$ 2>/dev/null
  exit
}
trap cleanup SIGINT SIGTERM

echo -e "${SYSTEM_COLOR}[${SYSTEM_PREFIX}]${RESET_COLOR} Starting dev environment..."

# Watch and Build
(find . -type f -name "*.typ" | entr -r uv run make.py 2>&1 | prefix_output "$BUILD_PREFIX" "$BUILD_COLOR") &

# Live Server
(live-server dist/ 2>&1 | prefix_output "$SERVER_PREFIX" "$SERVER_COLOR")