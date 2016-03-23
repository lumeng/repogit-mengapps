#!/usr/bin/env bash

## Summary: delete files listed in a file.
#+ Author: Meng Lu <lumeng.dev@gmail.com>
#+ History:
#+ * Copied from http://askubuntu.com/questions/596489/how-to-delete-files-listed-in-a-text-file.
##

if [ -z "$1" ]; then
    echo -e "Usage: $(basename $0) FILE # Each line in FILE is full paths to a file or directory.\n"
    exit 1
fi

if [ ! -e "$1" ]; then
    echo -e "$1: File doesn't exist.\n"
    exit 1
fi

while read -r line; do
    rmtrash "$line"
done < "$1

## END
