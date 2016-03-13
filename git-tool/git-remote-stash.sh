#!/usr/bin/env bash

GIT_STASH_TIMESTAMP=$(date +%s)

## Only run the command from the root path of a Git repository, so
## 'git add .' will add all files
if [[ ! -d .git ]]; then
	echo "$(pwd) is not a Git repository; Quit."
	exit 0;
fi

git stash

git checkout -b meng/remotestash${GIT_STASH_TIMESTAMP}

git stash pop

git add .

git commit -am stash

git push -u origin meng/remotestash${GIT_STASH_TIMESTAMP}

git checkout master

## END
