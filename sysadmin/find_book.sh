#!/usr/bin/env bash

FIND_CMD=gfind

type ${FIND_CMD} >/dev/null 2>&1 || { echo >&2 "This script requires command-line executable program 'wolframscript', that is installed along with Wolfram Mathematica version 11 or later. See more information at http://reference.wolfram.com/language/ref/program/wolframscript.html. Aborting."; exit 1; }

WILDCARDP=$2

WILDCARDP=$(gsed "s/ /*/g" <<<"${WILDCARDP}")

# echo "[DEBUG] WILDCARDP: ${WILDCARDP}"

while getopts ":ca" opt; do
  case ${opt} in
      c) # current
	 REGEXP=$(gsed "s/*/.*/g" <<<"${WILDCARDP}")
         F_REGEXP=".*\[[0-9]{4}-[0-9]{1,2}.*\].*${REGEXP}.*"
         ;;
      a) # all
	 REGEXP=$(gsed "s/*/.*/g" <<<"${WILDCARDP}")
         F_REGEXP=".*${REGEXP}.*"
         ;;
      \?) echo "Usage:
* current: find_book -c mypattern
* all: find_book -a mypattern
"
         F_REGEXP=".*"
         ;;
  esac
done

echo "wildcard pattern: *${WILDCARDP}*"
echo "regexp: ${F_REGEXP}"

echo "all matching books:

"

declare -a DIR=( \
"/Volumes/library1" \
"/Volumes/library2" \
"$HOME" \
"/Volumes/library6" \
"/Volumes/library3" \
"/Volumes/library4" \
"/Volumes/library5" \
"/Volumes/library7" \
"/Volumes/library8" \
)

# ${FIND_CMD} {/Volumes/{library1,library2,LIBRARY3,library4,library5,library6,librrary7,library8},~/DataSpace-Library,~/Downloads,~/DataSpace-Baidu,~/Google\ Drive} \
#       2>/dev/null \
#       -regextype posix-extended \
#       -iregex "${F_REGEXP}"

for d in "${DIR[@]}"; # @: c.f. https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion
do
    if [[ -d "$d" ]]; then
        #echo "[DEBUG] searching in ${d}:"
        tree --charset unicode \
            -P "*${WILDCARDP}*" \
	    --prune \
	    "${d}" \
	    2>/dev/null
    fi
done


echo "in-progress books:

"


for d in "${DIR[@]}"; # @: c.f. https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion
do
    if [[ -d "$d" ]]; then
        #echo "[DEBUG] searching in ${d}:"
        tree --charset unicode \
            -P "*\[20[0-9][0-9]*\]*${WILDCARDP}*" \
	    --prune \
	    "${d}" \
	    2>/dev/null
    fi
done

# END

