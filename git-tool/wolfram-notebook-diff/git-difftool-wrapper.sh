#!/usr/bin/env bash
##
## to-do:
##
## Mathematica .nb notebooks should be diffed with special tool.
##

# diff is called by git with 7 parameters:
# path old-file old-hex old-mode new-file new-hex new-mode

OLDFILE=$2
NEWFILE=$5

old_file_name=$(basename "$OLDFILE")
old_file_name_extension="${old_file_name##*.}"
old_file_name_base="${old_file_name%.*}"

new_file_name=$(basename "$NEWFILE")
new_file_name_extension="${new_file_name##*.}"
new_file_name_base="${new_file_name%.*}"

## Ignore lettercase for regex match.
shopt -s nocasematch

if [[ "$old_file_name_extension" =~ nb|cdf && "$new_file_name_extension" =~ nb|cdf ]]; then
	echo "diff-ing files with Wolfram format:
$2
$5
"
    wolfram-notebook-diff "$2" "$5"
	exit 0
else
# /Developer/Applications/Utilities/FileMerge.app
#
# opendiff is same as FileMerge
# "/usr/bin/opendiff" "$2" "$5" | cat

##
#+ Install from https://sourcegear.com/diffmerge/
##
#wolfram-notebook-diff "$2" "$5"
    diffmerge "$2" "$5"
fi

## END
