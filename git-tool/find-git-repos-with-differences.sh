#!/usr/bin/env bash

###############################################################################
#+ A Bash script to find in the current directory all Git repos that have
#+ unstaged, or uncommitted, or unpushed changes.
#+
#+ Author: Meng Lu <lumeng.dev@gmail.com>
#+ 
##

function git_has_changes {
    if git --git-dir="$1/.git" --work-tree="$1" diff-index --quiet HEAD --; then
        ## does not have changes
        #echo "$1 has no changes"
		return 0
    else
        ## has changes
        #echo "$1 has changes"
        echo "$1"
		return 1
    fi
}


TMPSUBDIR=$(mktemp -d "${TMPDIR:-/tmp/}$(basename 0).XXXXXXXXXXXX")

TIMESTAMP="$(date +%s)"
TMPFILE="${TMPSUBDIR}/tmp__${TIMESTAMP}.txt"
touch $TMPFILE

find . -type d -name '.git' -exec echo "$(basename {})" \; | sed -s 's/\/\.git$//g' > $TMPFILE

cat $TMPFILE | \
   while read line; do  git_has_changes "$line"; done


## END
