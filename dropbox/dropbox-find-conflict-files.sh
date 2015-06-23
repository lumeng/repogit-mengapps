#!/usr/bin/env bash

#######################################################################
#+ Find files in Dropbox directory (typically `$HOME/Dropbox`) that
#+ are Dropbox conflict copies whose file names are of the form
#+     XXX (YYY's conflict copy YYYY-MM-DD).ZZZ
##

find . -type f -regex ".* ([a-zA-Z0-9]+'s conflicted copy [-0-9]+).*" -exec ls -la '{}' \;

#######################################################################
#+ Find and mv the files to a different location for deletion.
##

# find . -type f -regex ".* ([a-zA-Z0-9]+'s conflicted copy [-0-9]+).*" -exec mv -la '{}' ~/temp/. \;

## END
