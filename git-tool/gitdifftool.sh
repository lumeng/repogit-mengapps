#!/usr/bin/env bash
##
## to-do:
##
## Mathematica .nb notebooks should be diffed with special tool.
##


# diff is called by git with 7 parameters:
# path old-file old-hex old-mode new-file new-hex new-mode

# /Developer/Applications/Utilities/FileMerge.app
#
# opendiff is same as FileMerge
# "/usr/bin/opendiff" "$2" "$5" | cat

#"/usr/bin/diffmerge" "$2" "$5" | cat
"/usr/bin/DiffMerge" "$2" "$5"

