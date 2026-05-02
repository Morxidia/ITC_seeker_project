#!/bin/bash

# this file take the first frame
# from mp4 and output to jpg
# this script required ffmpeg in order to run

# use 1 to delete after, removing the original file
DELETE_AFTER = "$1"

for file in *.mp4; do
  ffmpeg -i "$file" -frames:v 1 -q:v 2 "${file%.mp4}.jpg"
  if [[ DELETE_AFTER ]]; then
    rm "$file"
  fi
done
