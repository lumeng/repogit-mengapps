#!/usr/bin/env bash

#######################################################################
#+ Summary: convert non-MP3 files in current directory to MP3 using
#+ ffmpeg.
#+ Author: Meng Lu <lumeng.dev@gmail.com>
#+ 
#######################################################################

FILES=./*

type ffmpeg >/dev/null 2>&1 || { echo >&2 "This script requires ffmpeg but it's not installed.  Aborting."; exit 1; }

shopt -s nocasematch

for f in $FILES
do
	echo "Processing $f file ..."
	full_file_name=$(basename "$f")
	file_name_extension="${full_file_name##*.}"
	file_name="${full_file_name%.*}"
	if [[ ! $file_name_extension =~ "mp3" && ! -e "$file_name.mp3" ]]; then
		ffmpeg -i "$f" "$file_name.mp3"
	fi
done


