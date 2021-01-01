#!/usr/bin/env bash

DIFF_RESULT=$(/usr/bin/env wolfram-notebook-diff.wls "$1" "$2")

echo $DIFF_RESULT

if [[ $(uname) == 'Linux' ]]; then
    if [[ $(type xdg-open) ]]; then
	OPEN_BIN=xdg-open
    elif [[ $(type Mathematica) ]]; then
	OPEN_BIN=Mathematica
    else
	echo "[ERROR] cannot find a program to open Wolfram notebooks."
	exit 1
    fi
elif [[ $(uname) == 'Darwin' ]]; then
	OPEN_BIN=open
fi

$OPEN_BIN $DIFF_RESULT

exit 0

## END
