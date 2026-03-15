#!/bin/bash

export DIST_DIR="dist"
export STYLES_DIR="styles"
export SHARED_DIR="shared"
export POSTS_DIR="posts"

# Handle Args
if [ "$1" == "clean" ]; then
  echo "Cleaning dist ..."
  rm -rf "$DIST_DIR"
  echo "Cleaned."
  exit 0
fi

# Cleanup to run on SIGINT and SIGTERM
cleanup() {
  echo -e "\nStopping live-server and background watchers..."

  # 1. Prevent infinite recursion (removes the trap so our kill command doesn't re-trigger it)
  trap - SIGINT SIGTERM

  # 2. Kill the entire process group (-$$ targets all children of this script)
  kill -TERM -$$ 2>/dev/null

  # 3. Give processes a split second to actually die before fixing the terminal
  sleep 0.1

  # 4. Restore terminal sanity
  stty sane                      # Restores character echo and normal line formatting
  tput sgr0 2>/dev/null || true  # Resets text colors/formatting to default
  tput cnorm 2>/dev/null || true # Restores the cursor if any process hid it
  
  echo "Cleaned up successfully. Goodbye!"
  exit 0
}

trap cleanup SIGINT SIGTERM


copy_file() {
  local file=$1
  local dest_dir=""
  if [ -z "$file" ]; then
    return
  fi
  # We want to copy the file to its corresponding location in dist/
  # For example, if file is styles/blog.css, it should go to dist/styles/blog.css
  local dest="$DIST_DIR/$file"
  dest_dir=$(dirname "$dest")
  
  mkdir -p "$dest_dir"
  cp -v "$file" "$dest"
}
export -f copy_file

watch_typst() {
  local src=$1
  local dest=""
  local dest_dir=""
  
  # Rule: posts/index.typ --> dist/index.html
  # But index is an exception
  if [[ "$src" == *"$POSTS_DIR/index.typ" ]]; then
    dest="${DIST_DIR}/index.html"
  else
    # src already includes 'posts/', so appending it to dist/ works
    dest="${DIST_DIR}/${src%.typ}.html"
  fi
  
  dest_dir=$(dirname "$dest")
  mkdir -p "$dest_dir"
  
  #Using custom build of typst allowing ACE through #exec()
  typstex --color always \
          watch \
          --allow-exec \
          "$src" \
          "$dest" \
          --root . \
          --features html \
          --format html \
          --ignore-system-fonts \
          --no-serve \
          --no-reload \
          --diagnostic-format short \
          2>&1 | \
          grep -v -e '^[[:space:]]*$'
         
}
export -f watch_typst

# /_ is replaced by the path of the first file that changed
find $STYLES_DIR/ -type f | entr bash -c 'copy_file "$0"' /_ &
find $SHARED_DIR/ -type f | entr bash -c 'copy_file "$0"' /_ &
# Watch all .typ files in parallel
find "$POSTS_DIR" -type f -name "*.typ" | xargs --max-args=1 --max-procs=0 bash -c 'watch_typst "$0"' &
live-server $DIST_DIR/ &
qr http://$(lanip):8080 &

wait
