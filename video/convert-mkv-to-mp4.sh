#!/usr/bin/env bash

## Convert .mkv files from the given path to .mp4 format.

PATH="$1"

/usr/bin/find $PATH -iname '*.mkv' -print0 | while read -d '' -r file; do
    # ffmpeg -i "$file" -c:v copy -c:a copy ${file%%.mkv}.mp4
    /opt/local/bin/ffmpeg -i "$file" -c:v libx264 -crf 26 -c:a copy ${file%%.mkv}.mp4 # make file smaller using libx264 
done


## EOF
