#!/usr/bin/env bash

## ## Summary: play a sound depending on exit code of a command line program.
##
## ## Author: Meng Lu <lumeng.dev@gmail.com>
##
## ## Original author: Kevin Reid
##
## ## Reference:
## http://apple.stackexchange.com/questions/9412/how-to-get-a-notification-when-my-commands-are-done
## http://stackoverflow.com/questions/592620/how-to-check-if-a-program-exists-from-a-bash-script
##
## ## Examples:
##
## * Commit many large files all at once from command line and get audible notification when done:
## $ cvs commit -l -m "<commit message>" FooBar*.nb && notify.sh
##
##
## * CVS update from command line and get audible notification when done:
## $ cvs update -d -P "/Project/subdir" && notify.sh


if hash afplay 2>/dev/null; then
	if [[ "$@" -eq 0 ]]; then
		afplay -v 2 /System/Library/Sounds/Blow.aiff &
	else
		afplay -v 2 /System/Library/Sounds/Sosumi.aiff &
	fi
fi

if hash say 2>/dev/null; then
    say -v Alex "Task done at path $(basename "$(pwd)"), $@." &
fi


## END
