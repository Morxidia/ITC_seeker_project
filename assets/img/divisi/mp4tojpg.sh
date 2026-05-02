#!/bin/bash

# Fix the assignment (no spaces!)
DELETE_AFTER="$1"

find . -type f -name "*.mp4" | while read -r file; do
  # 1. THE EDIT: Ensure path starts with ./
  # Strip leading ./ if it exists, then prepend ./
  path_fixed="./${file#./}"

  # Define output name
  output="${path_fixed%.mp4}.jpg"

  echo "Processing: $path_fixed"

  # Run ffmpeg
  ffmpeg -loglevel error -y -i "$path_fixed" -frames:v 1 -q:v 2 "$output"

  if [[ "$DELETE_AFTER" == "1" ]]; then
    rm "$path_fixed"
    echo "Deleted original: $path_fixed"
  fi
done
