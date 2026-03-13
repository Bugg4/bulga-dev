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


copy_file() {
  local file=$1
  if [ -z "$file" ]; then
    return
  fi
  # We want to copy the file to its corresponding location in dist/
  # For example, if file is styles/blog.css, it should go to dist/styles/blog.css
  local dest="$DIST_DIR/$file"
  local dest_dir=$(dirname "$dest")
  
  mkdir -p "$dest_dir"
  cp -v "$file" "$dest"
}
export -f copy_file

watch_typst() {
  local src=$1
  local dest=""
  
  # Rule: posts/index.typ --> dist/index.html
  # But index is an exception
  if [[ "$src" == *"$POSTS_DIR/index.typ" ]]; then
    dest="${DIST_DIR}/index.html"
  else
    # src already includes 'posts/', so appending it to dist/ works
    dest="${DIST_DIR}/${src%.typ}.html"
  fi
  
  local dest_dir=$(dirname "$dest")
  mkdir -p "$dest_dir"
  
  typstex watch --allow-exec "$src" "$dest" --root . --features html --format html --ignore-system-fonts --no-serve --no-reload
}
export -f watch_typst

# /_ is replaced by the path of the first file that changed
find $STYLES_DIR/ -type f | entr -p bash -c 'copy_file "$0"' /_ &
find $SHARED_DIR/ -type f | entr -p bash -c 'copy_file "$0"' /_ &
find $POSTS_DIR/ -type f -name "*.typ" | parallel --line-buffer --tag watch_typst {} &
live-server $DIST_DIR/ &
wait
