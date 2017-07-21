#!/usr/bin/env bash

#######################################################################
#+ Summary: a wrapper to zip file preferrably using bzip2, but if it
#+ does not exist, use gzip.
#+ Author: Meng Lu <lumeng.dev@gmail.com>
#+
#+ Usage:
#+     compress-file-bzip2-gzip.sh myfile
#+
#+ * View gzip file on the fly:
#+
#+     zless data.txt.gz
#+     zmore data.txt.gz
#+
#+ More information about z* commands:
#+ http://www.cyberciti.biz/tips/decompress-and-expand-text-files.html
#+
#+ * View bzip2 file on the fly:
#+ Copy the following script to bzless.sh
#+ http://www.bzip.org/bzip2-howto/with-less.html
#+
#+     bzless myfile.bzip2
#+
##

FILE=$1

if [[ ! -f "$FILE" ]]; then
    echo >&2 '$FILE is not a regular file. Abort.'
    exit 1
fi

{ type bzip2 >/dev/null 2>&1 && \
      bzip2 -qz "$FILE" >/dev/null; } || \
	gzip -c "$FILE" > "$LOG_FILE.gz"

## END
