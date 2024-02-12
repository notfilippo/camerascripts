#!/bin/bash

# Usage: camilla.bash <image1> <image2> ...
# This script takes a list of images and creates a video for each of the, using
# the audio stream written by the camera.

process() {
  exiftool -b -AudioStream "$1" > "$1.WAV"
  # check if stream is empty
  if [ -s "$1.WAV" ]
  then
    echo "Found audio stream in $1"
    date=$(exiftool -T -DateTimeOriginal -d "%F %T" "$1")
    ffmpeg -y -loop 1 -i "$1" -i "$1.WAV" \
      -metadata creation_time="$date" \
      -shortest "$1.mp4"
  fi
  rm "$1.WAV"
}

export -f process
parallel --bar process ::: "$@"