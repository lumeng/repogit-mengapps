#!/usr/bin/env bash

## Summary: find all files in the current directory and tally their file name extensions
##
## ToDo:
## * test against different versions of grep
##
## Example:
##     $ App/file_system/tally_file_name_extension.sh
##     1851 .m
##       92 .bak
##        5 .~
##        1 .Log
##

DIR=${1:-`pwd`}

find ${DIR} -type f -exec basename {} \; `# find all files and extract their file names` \
    | grep -o -e '\.[^.]\+$' `# find ` \
    | sort \
    | uniq -c `#` \
    | sort -r # sort according to occurrences
