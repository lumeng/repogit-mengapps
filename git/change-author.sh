#!/bin/sh

## Summary: change identification (user name and email) in Git revision history

## Edit the following to specify what old identity you'd like to modify
export OLD_EMAIL="old_user@host.com"


## Edit the following to specify what the new user name and email address you want
export NEW_NAME="New User Name"
export NEW_EMAIL="new_user@host.com"

git filter-branch -f --env-filter '

an="$GIT_AUTHOR_NAME"
am="$GIT_AUTHOR_EMAIL"
cn="$GIT_COMMITTER_NAME"
cm="$GIT_COMMITTER_EMAIL"
 
if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
    cn="$NEW_NAME"
    cm="$NEW_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    an="$NEW_NAME"
    am="$NEW_EMAIL"
fi
 
export GIT_AUTHOR_NAME="$an"
export GIT_AUTHOR_EMAIL="$am"
export GIT_COMMITTER_NAME="$cn"
export GIT_COMMITTER_EMAIL="$cm"
'
