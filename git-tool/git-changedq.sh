#!/usr/bin/env bash

#######################################################################
#+ Test if this is Git repo
##

if [[ ! -d .git ]]; then
	echo >&2 "This is not a Git repository. Abort."
	exit 1
fi

#######################################################################
#+ Test if there is any stageable change.
##

#######################################################################
#+ Test if there is any commitable change.
##

git update-index -q --refresh  

if git diff-index --quiet --exit-code HEAD --; then
    echo "NOT COMMITABLE"
else
    echo "COMMITABLE"
fi


#######################################################################
#+ Test if there is any pushuable change.
##

git update-index -q --refresh

if git diff-index --quiet --exit-code HEAD --; then
    echo "NOT PUSHABLE"
else
    echo "NOT PUSHABLE"
fi

## END
