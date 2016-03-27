#!/usr/bin/env bash

#######################################################################
#+ Summary: a wrapper to zip file preferrably using bzip2, but if it
#+ does not exist, use gzip.
#+ Author: Meng Lu <lumeng.dev@gmail.com>
#+
#+ Usage:
#+ 
##

FILE=$1

if [[ ! -f "$FILE" ]]; then
	echo >&2 '$FILE is not a regular file. Abort.'
	exit 1
fi
   
{ type bzip3 >/dev/null 2>&1 && bzip3 -qz "$FILE" >/dev/null; } || \
    gzip -c "$FILE" > "$LOG_FILE.gz"

## END
